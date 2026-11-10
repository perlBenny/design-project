-- DB rule tests. Each test tries to insert or delete bad data and expects the DB to refuse.
-- Runs in CI and with `pnpm db:test`. Needs the base and dev seed.
-- Everything runs in one transaction that is rolled back, so no data is left behind.

\set ON_ERROR_STOP 1
begin;

-- expect_error(name, sql): passes only if running sql raises an error.
create function pg_temp.expect_error(test_name text, stmt text) returns void
language plpgsql as $$
begin
  begin
    execute stmt;
  exception when others then
    raise notice 'PASS  %', test_name;
    return;
  end;
  raise exception 'FAIL  % (the DB accepted bad data)', test_name;
end;
$$;

-- ---------- projects ----------
select pg_temp.expect_error('project: slug must be lower-case latin with dashes',
  $q$ insert into projects (title, slug) values ('x', 'Bad Slug') $q$);
select pg_temp.expect_error('project: slug must be unique',
  $q$ insert into projects (title, slug) values ('x', 'dira-tel-aviv') $q$);
select pg_temp.expect_error('project: title cannot be empty',
  $q$ insert into projects (title, slug) values ('', 'empty-title') $q$);
select pg_temp.expect_error('project: published needs published_at',
  $q$ insert into projects (title, slug, status) values ('x', 'no-date', 'published') $q$);
select pg_temp.expect_error('project: status must be draft or published',
  $q$ insert into projects (title, slug, status) values ('x', 'bad-status', 'hidden') $q$);
select pg_temp.expect_error('project: meta_description max 160 chars',
  $q$ insert into projects (title, slug, meta_description) values ('x', 'long-meta', repeat('a', 161)) $q$);

-- ---------- project_images ----------
select pg_temp.expect_error('image: alt is required',
  $q$ insert into project_images (project_id, storage_key, alt, width, height)
      select id, 'k-alt', '', 10, 10 from projects where slug = 'dira-tel-aviv' $q$);
select pg_temp.expect_error('image: width must be positive',
  $q$ insert into project_images (project_id, storage_key, alt, width, height)
      select id, 'k-width', 'a', 0, 10 from projects where slug = 'dira-tel-aviv' $q$);
select pg_temp.expect_error('image: project must exist',
  $q$ insert into project_images (project_id, storage_key, alt, width, height)
      values (uuidv7(), 'k-orphan', 'a', 10, 10) $q$);

insert into project_images (project_id, storage_key, alt, width, height, is_cover)
select id, 'test-cover-1', 'a', 10, 10, true from projects where slug = 'dira-tel-aviv';
select pg_temp.expect_error('image: only one cover per project',
  $q$ insert into project_images (project_id, storage_key, alt, width, height, is_cover)
      select id, 'test-cover-2', 'a', 10, 10, true from projects where slug = 'dira-tel-aviv' $q$);
select pg_temp.expect_error('image: storage_key must be unique',
  $q$ insert into project_images (project_id, storage_key, alt, width, height)
      select id, 'test-cover-1', 'a', 10, 10 from projects where slug = 'bayit-herzliya' $q$);

-- ---------- tips ----------
select pg_temp.expect_error('tip: image fields are all set or all empty',
  $q$ insert into tips (category_id, title, image_key)
      select id, 'x', 'only-key' from tip_categories where slug = 'lighting' $q$);
select pg_temp.expect_error('tip category: cannot delete while it has tips',
  $q$ delete from tip_categories where slug = 'lighting' $q$);
select pg_temp.expect_error('tip category: name must be unique',
  $q$ insert into tip_categories (name, slug) values ('תאורה', 'lighting-2') $q$);

-- ---------- users and RBAC ----------
select pg_temp.expect_error('user: email must be lower-case',
  $q$ insert into users (email, password_hash, role_id)
      select 'Admin@Example.com', 'h', id from roles where name = 'admin' $q$);
select pg_temp.expect_error('user: role must exist',
  $q$ insert into users (email, password_hash, role_id) values ('a@example.com', 'h', uuidv7()) $q$);
select pg_temp.expect_error('permission: name must look like area:action',
  $q$ insert into permissions (name) values ('projectswrite') $q$);

-- ---------- behaviour that must work ----------
do $$
declare changed boolean;
begin
  update projects set title = title || '!' where slug = 'dira-tel-aviv'
  returning updated_at > created_at into changed;
  if not changed then raise exception 'FAIL  updated_at did not change on update'; end if;
  raise notice 'PASS  updated_at changes on update';
end $$;

do $$
declare left_images int;
begin
  delete from projects where slug = 'dira-tel-aviv';
  select count(*) into left_images from project_images where storage_key = 'test-cover-1';
  if left_images <> 0 then raise exception 'FAIL  deleting a project did not delete its images'; end if;
  raise notice 'PASS  deleting a project deletes its images';
end $$;

do $$
begin
  if exists (select 1 from projects where uuid_extract_version(id) <> 7) then
    raise exception 'FAIL  ids are not UUID v7';
  end if;
  raise notice 'PASS  ids are UUID v7';
end $$;

-- Every foreign key column is the first column of some index.
-- Source: Supabase PostgreSQL Best Practices, p. 6 ("Index Foreign Key Columns").
do $$
declare
  missing text;
begin
  select string_agg(c.conrelid::regclass || '.' || a.attname, ', ') into missing
  from pg_constraint c
  join pg_attribute a on a.attrelid = c.conrelid and a.attnum = c.conkey[1]
  where c.contype = 'f'
    and not exists (
      select 1 from pg_index i where i.indrelid = c.conrelid and i.indkey[0] = c.conkey[1]
    );
  if missing is not null then
    raise exception 'FAIL  foreign keys without an index: %', missing;
  end if;
  raise notice 'PASS  every foreign key has an index';
end $$;

-- Data types: timestamptz (not timestamp), text (not varchar). dbmate's own table is skipped.
-- Source: Supabase PostgreSQL Best Practices, p. 6 ("Choose Appropriate Data Types").
do $$
declare
  bad text;
begin
  select string_agg(table_name || '.' || column_name || ' ' || data_type, ', ') into bad
  from information_schema.columns
  where table_schema = 'public' and table_name <> 'schema_migrations'
    and data_type in ('timestamp without time zone', 'character varying', 'character', 'real', 'double precision');
  if bad is not null then
    raise exception 'FAIL  columns with a discouraged type: %', bad;
  end if;
  raise notice 'PASS  column types follow the guidelines';
end $$;

rollback;
\echo 'All DB rule tests passed.'
