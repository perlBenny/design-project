-- migrate:up
-- Every foreign key needs an index: Postgres does not add one, and without it
-- "on delete set null" scans the whole table.
-- Source: Supabase PostgreSQL Best Practices, p. 6 ("Index Foreign Key Columns").
create index refresh_tokens_replaced_by_idx on refresh_tokens (replaced_by);

-- migrate:down
drop index refresh_tokens_replaced_by_idx;
