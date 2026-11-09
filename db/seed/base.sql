-- Base seed: runs in EVERY environment, including prod.
-- Safe to run many times (no duplicates).
-- The admin user is NOT created here: the backend creates it (task #6),
-- because the password must be hashed with the same argon2 code used at login.

insert into roles (name, description) values
  ('admin',  'The designer. Full access.'),
  ('editor', 'Content editor. Not assigned to anyone yet.')
on conflict (name) do update set description = excluded.description;

insert into permissions (name, description) values
  ('projects:write', 'Create, edit, publish and delete projects'),
  ('tips:write',     'Create, edit, publish and delete tip categories and tips'),
  ('media:upload',   'Upload and delete images'),
  ('users:manage',   'Manage users and roles')
on conflict (name) do update set description = excluded.description;

-- admin: every permission. editor: content only.
insert into role_permissions (role_id, permission_id)
select r.id, p.id
from roles r
join permissions p
  on r.name = 'admin'
  or (r.name = 'editor' and p.name in ('projects:write', 'tips:write', 'media:upload'))
on conflict do nothing;
