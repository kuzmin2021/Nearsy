begin;

alter table public.profiles
  alter column languages type text
    using case
      when languages is null then null
      else array_to_string(languages, ', ')
    end,
  alter column height type text
    using height::text,
  alter column kids type text
    using case
      when kids is null then null
      when kids then 'i_have_kids'
      else 'i_dont_have_kids'
    end;

commit;
