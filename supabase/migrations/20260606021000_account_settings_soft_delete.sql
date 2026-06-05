begin;

insert into public.user_settings (user_id)
select u.id
from auth.users u
left join public.user_settings s on s.user_id = u.id
where s.user_id is null;

create or replace function public.set_user_settings_updated_at()
returns trigger
language plpgsql
set search_path to 'public'
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_user_settings_updated_at on public.user_settings;
create trigger set_user_settings_updated_at
before update on public.user_settings
for each row
execute function public.set_user_settings_updated_at();

create or replace function public.create_user_settings_for_new_user()
returns trigger
language plpgsql
security definer
set search_path to 'public'
as $$
begin
  insert into public.user_settings (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists create_user_settings_after_auth_insert on auth.users;
create trigger create_user_settings_after_auth_insert
after insert on auth.users
for each row
execute function public.create_user_settings_for_new_user();

create or replace function public.delete_account_data_v2()
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
begin
  update public.profiles
  set
    deleted_at = now(),
    is_hidden = true,
    updated_at = now()
  where user_id = auth.uid()
    and deleted_at is null;
end;
$$;

commit;
