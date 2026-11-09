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

## Git workflow

`main` is protected. Every feature is developed on its own branch and merged through a PR after CI passes.
