-- migrate:up

create table projects (
  id               uuid primary key default uuidv7(),
  title            text not null check (length(title) between 1 and 200),
  -- URL part, e.g. "dira-tel-aviv": lower-case latin letters, digits and single dashes.
  slug             text not null unique
                   check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$' and length(slug) <= 100),
  description      text not null default '',          -- Markdown
  meta_description text not null default '' check (length(meta_description) <= 160),
  status           text not null default 'draft' check (status in ('draft', 'published')),
  published_at     timestamptz,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  -- A published project always has a publish date.
  check (status = 'draft' or published_at is not null)
);

-- Public list: published projects, newest first.
create index projects_status_published_at_idx on projects (status, published_at desc);

create trigger projects_set_updated_at before update on projects
  for each row execute function set_updated_at();

-- Image files live in S3 storage; this table holds only their metadata.
-- Deleting a project deletes these rows; the backend must delete the files.
create table project_images (
  id          uuid primary key default uuidv7(),
  project_id  uuid not null references projects (id) on delete cascade,
  storage_key text not null unique,
  alt         text not null check (length(alt) between 1 and 250),
  caption     text not null default '',
  width       integer not null check (width > 0),
  height      integer not null check (height > 0),
  sort_order  integer not null default 0,
  is_cover    boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index project_images_project_id_sort_order_idx on project_images (project_id, sort_order);

-- At most one cover image per project.
create unique index project_images_one_cover_idx on project_images (project_id) where is_cover;

create trigger project_images_set_updated_at before update on project_images
  for each row execute function set_updated_at();

-- migrate:down

drop table project_images;
drop table projects;
