-- migrate:up

create table tip_categories (
  id                 uuid primary key default uuidv7(),
  name               text not null unique check (length(name) between 1 and 100),
  slug               text not null unique
                     check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$' and length(slug) <= 100),
  intro              text not null default '',          -- Markdown
  meta_description   text not null default '' check (length(meta_description) <= 160),
  -- Optional cover image: either all four fields are set, or none.
  cover_image_key    text,
  cover_image_alt    text check (length(cover_image_alt) between 1 and 250),
  cover_image_width  integer check (cover_image_width > 0),
  cover_image_height integer check (cover_image_height > 0),
  sort_order         integer not null default 0,
  status             text not null default 'draft' check (status in ('draft', 'published')),
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  check (num_nulls(cover_image_key, cover_image_alt, cover_image_width, cover_image_height) in (0, 4))
);

create index tip_categories_status_sort_order_idx on tip_categories (status, sort_order);

create trigger tip_categories_set_updated_at before update on tip_categories
  for each row execute function set_updated_at();

create table tips (
  id           uuid primary key default uuidv7(),
  -- restrict: a category that still has tips cannot be deleted.
  category_id  uuid not null references tip_categories (id) on delete restrict,
  title        text not null check (length(title) between 1 and 200),
  body         text not null default '',               -- Markdown
  -- Optional image: either all four fields are set, or none.
  image_key    text,
  image_alt    text check (length(image_alt) between 1 and 250),
  image_width  integer check (image_width > 0),
  image_height integer check (image_height > 0),
  sort_order   integer not null default 0,
  status       text not null default 'draft' check (status in ('draft', 'published')),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  check (num_nulls(image_key, image_alt, image_width, image_height) in (0, 4))
);

create index tips_category_id_sort_order_idx on tips (category_id, sort_order);

create trigger tips_set_updated_at before update on tips
  for each row execute function set_updated_at();

-- migrate:down

drop table tips;
drop table tip_categories;
