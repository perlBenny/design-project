-- migrate:up

-- Shared helper: keeps updated_at current on every UPDATE.
create function set_updated_at() returns trigger
language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table roles (
  id          uuid primary key default uuidv7(),
  name        text not null unique check (name ~ '^[a-z_]+$'),
  description text not null default '',
  created_at  timestamptz not null default now()
);

-- Permission names look like "projects:write".
create table permissions (
  id          uuid primary key default uuidv7(),
  name        text not null unique check (name ~ '^[a-z_]+:[a-z_]+$'),
  description text not null default '',
  created_at  timestamptz not null default now()
);

create table role_permissions (
  role_id       uuid not null references roles (id) on delete cascade,
  permission_id uuid not null references permissions (id) on delete cascade,
  primary key (role_id, permission_id)
);

create index role_permissions_permission_id_idx on role_permissions (permission_id);

create table users (
  id            uuid primary key default uuidv7(),
  -- Stored lower-case so "Admin@x.com" and "admin@x.com" are the same user.
  email         text not null unique
                check (email = lower(email) and length(email) <= 254 and position('@' in email) > 1),
  password_hash text not null,
  role_id       uuid not null references roles (id) on delete restrict,
  is_active     boolean not null default true,
  last_login_at timestamptz,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index users_role_id_idx on users (role_id);

create trigger users_set_updated_at before update on users
  for each row execute function set_updated_at();

-- migrate:down

drop table users;
drop table role_permissions;
drop table permissions;
drop table roles;
drop function set_updated_at();
