CREATE OR REPLACE FUNCTION "public"."get_inbound_likes_v2"(
  "p_filter" "text" DEFAULT 'all',
  "p_limit" integer DEFAULT 50,
  "p_offset" integer DEFAULT 0
) RETURNS TABLE(
  "profile_id" bigint,
  "user_id" "uuid",
  "display_name" "text",
  "age" integer,
  "gender" "text",
  "avatar_url" "text",
  "photos" "jsonb",
  "location_label" "text",
  "distance_km" double precision,
  "liked_at" timestamp with time zone
)
LANGUAGE "sql" STABLE SECURITY DEFINER
SET "search_path" TO 'public'
AS $_$
  with
  me as (
    select p.user_id, p.location
    from public.profiles p
    where p.user_id = auth.uid()
    limit 1
  ),
  my_prefs as (
    select
      pref.min_age,
      pref.max_age,
      pref.max_distance_km,
      pref.preferred_genders
    from public.user_preferences pref
    where pref.user_id = auth.uid()
    limit 1
  ),
  inbound as (
    select
      se.user_id as liker_id,
      se.created_at as liked_at
    from public.swipe_events se
    where se.target_user_id = auth.uid()
      and se.action = 'like'
  ),
  candidates as (
    select
      p.*,
      i.liked_at,
      case
        when p.birthday ~ '^\d{4}-\d{2}-\d{2}$'
        then date_part('year', age(p.birthday::date))::int
        else null
      end as age_years
    from public.profiles p
    join inbound i on i.liker_id = p.user_id
    where p.deleted_at is null
      and p.is_hidden = false
  )
  select
    p.id,
    p.user_id,
    p.display_name,
    p.age_years,
    p.gender,
    p.avatar_url,
    coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'path', up.photo_url,
            'position', up.position
          )
          order by up.position
        )
        from public.user_photos up
        where up.user_id = p.user_id
          and up.deleted_at is null
          and up.photo_url is not null
      ),
      '[]'::jsonb
    ),
    p.location_label,
    case
      when (select location from me) is null or p.location is null then null
      else st_distance((select location from me), p.location) / 1000.0
    end,
    p.liked_at
  from candidates p
  cross join me
  cross join my_prefs
  where (
    p_filter = 'all'
    or (
      p_filter = 'matches'
      and (my_prefs.min_age is null or p.age_years is null or p.age_years >= my_prefs.min_age)
      and (my_prefs.max_age is null or p.age_years is null or p.age_years <= my_prefs.max_age)
      and (
        my_prefs.max_distance_km is null
        or me.location is null
        or p.location is null
        or st_dwithin(me.location, p.location, my_prefs.max_distance_km * 1000.0)
      )
      and (my_prefs.preferred_genders is null or array_length(my_prefs.preferred_genders, 1) is null or p.gender = any(my_prefs.preferred_genders))
    )
    or (
      p_filter = 'outside'
      and (
        (my_prefs.min_age is not null and p.age_years is not null and p.age_years < my_prefs.min_age)
        or (my_prefs.max_age is not null and p.age_years is not null and p.age_years > my_prefs.max_age)
        or (
          my_prefs.max_distance_km is not null
          and me.location is not null
          and p.location is not null
          and not st_dwithin(me.location, p.location, my_prefs.max_distance_km * 1000.0)
        )
        or (my_prefs.preferred_genders is not null and array_length(my_prefs.preferred_genders, 1) is not null and not (p.gender = any(my_prefs.preferred_genders)))
      )
    )
  )
  order by p.liked_at desc
  limit greatest(0, p_limit)
  offset greatest(0, p_offset);
$_$;


ALTER FUNCTION "public"."get_inbound_likes_v2"("p_filter" "text", "p_limit" integer, "p_offset" integer) OWNER TO "postgres";

GRANT ALL ON FUNCTION "public"."get_inbound_likes_v2"("p_filter" "text", "p_limit" integer, "p_offset" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_inbound_likes_v2"("p_filter" "text", "p_limit" integer, "p_offset" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_inbound_likes_v2"("p_filter" "text", "p_limit" integer, "p_offset" integer) TO "service_role";
