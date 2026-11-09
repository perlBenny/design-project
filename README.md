# Design Project

Portfolio website for an interior designer (Hebrew, RTL, SEO-first).

## Structure

| Path                               | Purpose                                                         |
| ---------------------------------- | --------------------------------------------------------------- |
| `frontend/`                        | React + TanStack Start (SSR), Mantine + CSS Modules             |
| `backends/node/`                   | Fastify + TypeScript + Prisma (main backend)                    |
| `backends/go/`, `backends/python/` | Future backends, same API contract                              |
| `db/migrations/`, `db/seed/`       | SQL migrations (dbmate) — single source of truth for the schema |
| `api-spec/`                        | `openapi.yaml` — the API contract                               |
| `tests/e2e/`                       | Shared API E2E suite, runs against any backend via `API_URL`    |
| `infra/caddy/`                     | Reverse proxy config for local prod                             |

See [docs/SPEC.md](docs/SPEC.md) for the full specification.

## Requirements

- Node 26 LTS (`.nvmrc`)
- pnpm
- Docker Desktop (WSL2)

## Getting started

```bash
cp .env.example .env.dev
pnpm install
pnpm dev          # starts Postgres + storage, runs migrations and seed
```

## Database

The schema lives only in `db/migrations` (plain SQL, run by dbmate in Docker).
Backends never change it. `db/schema.sql` is generated — commit it, never edit it.

| Command                 | What it does                                      |
| ----------------------- | ------------------------------------------------- |
| `pnpm db:migrate`       | Apply new migrations and update `db/schema.sql`   |
| `pnpm db:rollback`      | Undo the last migration                           |
| `pnpm db:status`        | Show which migrations ran                         |
| `pnpm db:new add_thing` | Create a new empty migration file                 |
| `pnpm db:seed`          | Load roles and permissions (+ sample data in dev) |
| `pnpm db:test`          | Check that the DB rules reject bad data           |
| `pnpm db:reset`         | Drop the dev database and rebuild it from scratch |

## Git workflow

`main` is protected. Every feature is developed on its own branch and merged through a PR after CI passes.
