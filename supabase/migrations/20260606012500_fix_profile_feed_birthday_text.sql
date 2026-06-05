begin;

create or replace function public.get_discovery_feed_v2(
  p_limit integer default 20,
  p_offset integer default 0
) returns table(
  profile_id bigint,
  user_id uuid,
  display_name text,
  age integer,
  gender text,
  catchphrase text,
  description text,
  avatar_url text,
  distance_km double precision,
  photos jsonb
)
language sql
stable
security definer
set search_path to 'public'
as $$
  with me as (
    select p.user_id, p.location, pref.*
    from public.profiles p
    left join public.user_preferences pref on pref.user_id = p.user_id
    where p.user_id = auth.uid()
    limit 1
  ),
  candidates as (
    select
      p.*,
      case
        when p.birthday ~ '^\d{4}-\d{2}-\d{2}$'
        then date_part('year', age(p.birthday::date))::int
        else null
      end as age_years
    from public.profiles p
  )
  select
    p.id,
    p.user_id,
    p.display_name,
    p.age_years,
    p.gender,
    p.catchphrase,
    p.description,
    p.avatar_url,
    case
      when (select location from me) is null or p.location is null then null
      else st_distance((select location from me), p.location) / 1000.0
    end,
    coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'id', up.id,
            'path', coalesce(up.storage_path, up.photo_path),
            'position', up.position,
            'is_main', up.is_main
          )
          order by up.position
        )
        from public.user_photos up
        where up.user_id = p.user_id
          and up.deleted_at is null
          and coalesce(up.storage_path, up.photo_path) is not null
      ),
      '[]'::jsonb
    )
  from candidates p
  cross join me
  where p.user_id <> auth.uid()
    and p.deleted_at is null
    and p.is_hidden = false
    and p.location_mode <> 'invisible'
    and (me.preferred_genders is null or p.gender = any(me.preferred_genders))
    and (me.min_age is null or p.age_years is null or p.age_years >= me.min_age)
    and (me.max_age is null or p.age_years is null or p.age_years <= me.max_age)
    and (
      me.max_distance_km is null
      or me.location is null
      or p.location is null
      or st_dwithin(me.location, p.location, me.max_distance_km * 1000.0)
    )
    and not exists (
      select 1
      from public.swipe_events s
      where s.user_id = auth.uid()
        and s.target_user_id = p.user_id
    )
    and not exists (
      select 1
      from public.blocks b
      where (b.blocker = auth.uid() and b.blocked = p.user_id)
         or (b.blocker = p.user_id and b.blocked = auth.uid())
    )
  order by (
    case
      when (select location from me) is null or p.location is null then null
      else st_distance((select location from me), p.location) / 1000.0
    end
  ) nulls last, p.updated_at desc
  limit greatest(0, p_limit)
  offset greatest(0, p_offset);
$$;

create or replace function public.get_nearby_profiles_v2(
  p_radius_km integer default 25,
  p_limit integer default 50
) returns table(
  profile_id bigint,
  user_id uuid,
  display_name text,
  age integer,
  gender text,
  avatar_url text,
  location_label text,
  distance_km double precision
)
language sql
stable
security definer
set search_path to 'public'
as $$
  with me as (
    select location
    from public.profiles
    where user_id = auth.uid()
    limit 1
  ),
  candidates as (
    select
      p.*,
      case
        when p.birthday ~ '^\d{4}-\d{2}-\d{2}$'
        then date_part('year', age(p.birthday::date))::int
        else null
      end as age_years
    from public.profiles p
  )
  select
    p.id,
    p.user_id,
    p.display_name,
    p.age_years,
    p.gender,
    p.avatar_url,
    p.location_label,
    st_distance((select location from me), p.location) / 1000.0
  from candidates p
  where p.user_id <> auth.uid()
    and p.deleted_at is null
    and p.is_hidden = false
    and p.location_mode <> 'invisible'
    and (select location from me) is not null
    and p.location is not null
    and st_dwithin((select location from me), p.location, p_radius_km * 1000.0)
    and not exists (
      select 1
      from public.blocks b
      where (b.blocker = auth.uid() and b.blocked = p.user_id)
         or (b.blocker = p.user_id and b.blocked = auth.uid())
    )
  order by st_distance((select location from me), p.location)
  limit greatest(0, p_limit);
$$;

commit;
