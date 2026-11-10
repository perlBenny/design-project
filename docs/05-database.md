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

## DB tests

[`db/tests/constraints.sql`](../db/tests/constraints.sql) tries to insert bad data and expects an error.
It runs inside a transaction that is rolled back, so it leaves nothing behind.

```bash
pnpm db:test
```

**Rule:** a new DB rule needs a new test here.
