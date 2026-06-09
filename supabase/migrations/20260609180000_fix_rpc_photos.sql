CREATE OR REPLACE FUNCTION public.get_discovery_feed_v2(p_limit integer DEFAULT 20, p_offset integer DEFAULT 0)
RETURNS TABLE(profile_id bigint, user_id uuid, display_name text, age integer, gender text, catchphrase text, description text, avatar_url text, distance_km double precision, photos jsonb, location_label text, work text, education text, kids text, relationship_type text, religion text, body_type text, exercise text, drinking text, smoking text, height text, languages text)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path TO 'public'
AS $$
  with me as (
    select p.user_id, p.location, pref.min_age, pref.max_age, pref.max_distance_km, pref.preferred_genders
    from public.profiles p
    left join public.user_preferences pref on pref.user_id = p.user_id
    where p.user_id = auth.uid()
    limit 1
  ),
  candidates as (
    select p.*, case when p.birthday ~ E'^\\d{4}-\\d{2}-\\d{2}$' then date_part('year', age(p.birthday::date))::int else null end as age_years
    from public.profiles p
  )
  select p.id, p.user_id, p.display_name, p.age_years, p.gender, p.catchphrase, p.description, p.avatar_url,
    case when (select location from me) is null or p.location is null then null else st_distance((select location from me), p.location) / 1000.0 end,
    coalesce((select jsonb_agg(jsonb_build_object('id', up.id, 'path', up.photo_url, 'position', up.position) order by up.position) from public.user_photos up where up.user_id = p.user_id and up.deleted_at is null and up.photo_url is not null), '[]'::jsonb),
    p.location_label, p.work, p.education, p.kids, p.relationship_type, p.religion, p.body_type, p.exercise, p.drinking, p.smoking, p.height, p.languages
  from candidates p cross join me
  where p.user_id <> auth.uid() and p.deleted_at is null and p.is_hidden = false and p.location_mode <> 'invisible'
    and (me.preferred_genders is null or p.gender = any(me.preferred_genders))
    and (me.min_age is null or p.age_years is null or p.age_years >= me.min_age)
    and (me.max_age is null or p.age_years is null or p.age_years <= me.max_age)
    and (me.max_distance_km is null or me.location is null or p.location is null or st_dwithin(me.location, p.location, me.max_distance_km * 1000.0))
    and not exists (select 1 from public.swipe_events s where s.user_id = auth.uid() and s.target_user_id = p.user_id)
    and not exists (select 1 from public.blocks b where (b.blocker = auth.uid() and b.blocked = p.user_id) or (b.blocker = p.user_id and b.blocked = auth.uid()))
  order by
    (case when (select location from me) is null or p.location is null then null else st_distance((select location from me), p.location) / 1000.0 end) nulls last,
    p.updated_at desc
  limit greatest(0, p_limit) offset greatest(0, p_offset);
$$;
