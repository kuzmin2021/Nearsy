ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS location geography(POINT, 4326);
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS public_location geography(POINT, 4326);
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS public_location_updated_at timestamptz;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS public_location_expires_at timestamptz;
ALTER TABLE public.profiles ALTER COLUMN location_mode SET DEFAULT 'invisible';
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS nearby_radius_km integer DEFAULT 25;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS nearby_limit integer DEFAULT 50;

CREATE INDEX IF NOT EXISTS idx_profiles_location ON public.profiles USING GIST (location);
CREATE INDEX IF NOT EXISTS idx_profiles_public_location ON public.profiles USING GIST (public_location);

DROP FUNCTION IF EXISTS public.get_nearby_profiles_v3(double precision, double precision, integer, integer);
DROP FUNCTION IF EXISTS public.get_my_nearby_presence();
DROP FUNCTION IF EXISTS public.update_nearby_presence(double precision, double precision);

CREATE OR REPLACE FUNCTION public.update_nearby_presence(
  p_lat double precision,
  p_lng double precision
) RETURNS void
LANGUAGE plpgsql
VOLATILE
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_mode text;
  v_private_location geography := ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography;
  v_public_location geography;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN;
  END IF;

  SELECT COALESCE(location_mode, 'invisible')
    INTO v_mode
    FROM public.profiles
   WHERE user_id = v_user_id;

  IF v_mode IS NULL THEN
    v_mode := 'invisible';
  END IF;

  IF v_mode <> 'invisible' THEN
    v_public_location := ST_Project(
      v_private_location,
      500.0 + random() * 500.0,
      random() * 2.0 * pi()
    );
  END IF;

  UPDATE public.profiles
     SET location = v_private_location,
         public_location = CASE
           WHEN v_mode = 'invisible' THEN NULL
           ELSE v_public_location
         END,
         public_location_updated_at = CASE
           WHEN v_mode = 'invisible' THEN NULL
           ELSE now()
         END,
         public_location_expires_at = CASE
           WHEN v_mode = 'frozen' THEN now() + interval '24 hours'
           ELSE NULL
         END
   WHERE user_id = v_user_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_my_nearby_presence()
RETURNS TABLE(
  profile_id bigint,
  user_id uuid,
  latitude double precision,
  longitude double precision,
  presence_type text
) LANGUAGE sql STABLE AS $$
  SELECT
    p.id,
    p.user_id,
    ST_Y(p.public_location::geometry) AS latitude,
    ST_X(p.public_location::geometry) AS longitude,
    CASE
      WHEN p.location_mode = 'frozen' THEN 'frozen'
      ELSE 'live'
    END AS presence_type
  FROM public.profiles p
  WHERE p.user_id = auth.uid()
    AND p.deleted_at IS NULL
    AND p.is_hidden = false
    AND p.location_mode <> 'invisible'
    AND p.public_location IS NOT NULL
    AND (
      (
        p.location_mode = 'visible'
        AND p.public_location_updated_at >= now() - interval '5 minutes'
      )
      OR (
        p.location_mode = 'frozen'
        AND p.public_location_expires_at > now()
      )
    )
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.get_nearby_profiles_v3(
  p_lat double precision,
  p_lng double precision,
  p_radius_km integer DEFAULT 25,
  p_limit integer DEFAULT 50
) RETURNS TABLE(
  profile_id bigint,
  user_id uuid,
  display_name text,
  age integer,
  gender text,
  avatar_url text,
  location_label text,
  distance_km double precision,
  latitude double precision,
  longitude double precision,
  presence_type text
) LANGUAGE sql STABLE AS $$
  SELECT
    p.id,
    p.user_id,
    p.display_name,
    CASE
      WHEN p.birthday ~ '^\d{4}-\d{2}-\d{2}$'
      THEN date_part('year', age(p.birthday::date))::int
      ELSE NULL
    END AS age,
    p.gender,
    p.avatar_url,
    p.location_label,
    ST_Distance(p.public_location, ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography) / 1000.0 AS distance_km,
    ST_Y(p.public_location::geometry) AS latitude,
    ST_X(p.public_location::geometry) AS longitude,
    CASE
      WHEN p.location_mode = 'frozen' THEN 'frozen'
      ELSE 'live'
    END AS presence_type
  FROM public.profiles p
  WHERE p.deleted_at IS NULL
    AND p.is_hidden = false
    AND p.location_mode <> 'invisible'
    AND p.public_location IS NOT NULL
    AND (
      (
        p.location_mode = 'visible'
        AND p.public_location_updated_at >= now() - interval '5 minutes'
      )
      OR (
        p.location_mode = 'frozen'
        AND p.public_location_expires_at > now()
      )
    )
    AND ST_DWithin(p.public_location, ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography, p_radius_km * 1000)
  ORDER BY distance_km
  LIMIT p_limit;
$$;

GRANT ALL ON FUNCTION public.get_my_nearby_presence() TO anon, authenticated, service_role;
GRANT ALL ON FUNCTION public.update_nearby_presence(double precision, double precision) TO anon, authenticated, service_role;
GRANT ALL ON FUNCTION public.get_nearby_profiles_v3(double precision, double precision, integer, integer) TO anon, authenticated, service_role;
