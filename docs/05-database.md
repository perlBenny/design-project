# 5. Database

## One owner for the schema

The schema is plain SQL in [`db/migrations`](../db/migrations), run by [dbmate](https://github.com/amacneil/dbmate)
in Docker. Backends never change it. This lets three backends in three languages share one DB.

## Tables

| Table                                      | Holds                                                    |
| ------------------------------------------ | -------------------------------------------------------- |
| `users`                                    | Admin panel users (email always lower case)              |
| `roles`, `permissions`, `role_permissions` | RBAC: who may do what                                    |
| `refresh_tokens`                           | Login sessions: `family_id`, `token_hash`, `replaced_by` |
| `projects`, `project_images`               | Portfolio projects and their images                      |
| `tip_categories`, `tips`                   | Design tips, grouped by category                         |

IDs are **UUID v7**: unique like any UUID, but sorted by time, so indexes stay fast.

## Rules live in the DB

The app checks input too, but the DB is the last line of defense. Examples:

| Rule                                               | How                                |
| -------------------------------------------------- | ---------------------------------- |
| Slugs look like `modern-kitchen`                   | `check` with a regex               |
| A published project has a `published_at` date      | `check`                            |
| `meta_description` is at most 160 characters (SEO) | `check`                            |
| Every image has alt text (SEO, accessibility)      | `not null` + `check`               |
| A project has at most one cover image              | partial unique index               |
| Tip image fields are all set or all empty          | `check (num_nulls(...) in (0, n))` |
| You can't delete a category that still has tips    | `on delete restrict`               |
| `updated_at` is always correct                     | trigger `set_updated_at()`         |

## Migrations

```bash
pnpm db:new add_thing   # new file in db/migrations
pnpm db:migrate         # apply, and regenerate db/schema.sql
pnpm db:rollback        # undo the last one
```

Every migration has `-- migrate:up` and `-- migrate:down`. CI rolls back **every** migration
and applies them again, then checks `db/schema.sql` did not change. So a broken `down` is caught.

## Seed

- `base.sql`: roles `admin` and `editor`, and 4 permissions. Always loaded.
- `dev.sql`: sample projects, categories and tips in Hebrew. Loaded only when `SEED_SAMPLE_DATA=true`.

Seeds are **idempotent**: running them twice adds nothing. CI runs them twice to prove it.

The first admin user is not seeded. It will be created by a backend command (planned, issue #6).

## Browse the DB with pgAdmin

```bash
pnpm db:ui        # opens pgAdmin on http://localhost:5050
pnpm db:ui:stop   # stop it
```

The dev DB (`designer-dev`) is already registered and signed in, using the user and password from `.env.dev`.
Open **Servers → designer-dev → Databases → designer_dev → Schemas → public → Tables**,
right-click a table → **View/Edit Data**. For SQL: **Tools → Query Tool**.

- No pgAdmin login (desktop mode). That is safe only because it listens on `127.0.0.1`, never on the network.
- First start takes ~20 seconds.
- Look, query, try things. **Don't change the structure** (tables, columns) here: that goes through a
  migration, or `db/schema.sql` and CI will disagree with your DB. `pnpm db:reset` fixes a broken dev DB.

## DB tests

[`db/tests/constraints.sql`](../db/tests/constraints.sql) tries to insert bad data and expects an error.
It runs inside a transaction that is rolled back, so it leaves nothing behind.

```bash
pnpm db:test
```

**Rule:** a new DB rule needs a new test here.

## Checked against the book

We checked the schema against _Supabase PostgreSQL Best Practices_ (Trove shelf, see [AI knowledge](11-ai-knowledge.md)).
Rules that can be checked by a machine are now DB tests, so they stay true.

| Rule (book, page)                                   | Status                                                                                                        |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| UUID v7, not random v4, for exposed IDs (p. 6)      | OK. Test: `ids are UUID v7`                                                                                   |
| `timestamptz`, `text`, no `varchar`/float (p. 6)    | OK. Test: `column types follow the guidelines`                                                                |
| Index every foreign key column (p. 6)               | **Was missing** on `refresh_tokens.replaced_by`. Fixed by a migration. Test: `every foreign key has an index` |
| Index columns used in `where` / `order by` (p. 2)   | OK. Composite indexes for list pages (`status, published_at`)                                                 |
| Partial indexes for filtered rules (p. 2)           | OK. One cover image per project                                                                               |
| Lower-case identifiers (p. 6)                       | OK                                                                                                            |
| Least privilege: the app is not the DB owner (p. 5) | **Planned** (backend phase): a separate app role with only the grants it needs                                |
| Row Level Security (p. 5)                           | Not needed: no multi-tenant data. Access is checked by RBAC in the API                                        |
| Pooling, pagination, `EXPLAIN` (p. 3, 8, 9)         | **Planned**: these are about queries, checked when the backend is built                                       |
