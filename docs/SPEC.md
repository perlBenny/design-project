# Specification

## Product

- Interior designer portfolio. Hebrew only, RTL.
- SEO is top priority: SSR, per-page meta, Open Graph, JSON-LD (`LocalBusiness`), `sitemap.xml`, `robots.txt`, canonical URLs, Lighthouse 90+.
- Accessibility: Israeli standard 5568, with an accessibility statement page.
- Questionnaire: future feature.
- Brand: provided later; placeholder theme in one file.

## Public pages

`/` (carousel of 6 latest projects, no autoplay), `/projects`, `/projects/:slug`, `/tips`, `/tips/:slug`, `/about`, `/contact` (static WhatsApp/email/phone), `/accessibility`, `/privacy`, 404.

## Admin (`/admin/*`, same frontend)

Lazy-loaded, `noindex`, blocked in `robots.txt`.

- Login
- Projects: create, edit, publish, delete, upload and reorder images
- Tip categories and tips: create, edit, publish, delete

## Data model (`/db/migrations`, dbmate)

| Table                                      | Main fields                                                                               |
| ------------------------------------------ | ----------------------------------------------------------------------------------------- |
| `users`                                    | email, password_hash (argon2), role_id                                                    |
| `roles`, `permissions`, `role_permissions` | RBAC: `admin`, `editor` (unused for now)                                                  |
| `refresh_tokens`                           | token_hash, user_id, expires_at, revoked_at                                               |
| `projects`                                 | title, slug, description (Markdown), meta_description, status, published_at, timestamps   |
| `project_images`                           | project_id, storage_key, alt, caption, width, height, sort_order, is_cover                |
| `tip_categories`                           | name, slug, intro (Markdown), meta_description, cover image key + alt, sort_order, status |
| `tips`                                     | category_id, title, body (Markdown), image key + alt, sort_order, status, timestamps      |

Backends never change the schema. Prisma uses `db pull` only — never `prisma migrate`.

## Architecture

```
Browser → TanStack Start (SSR) → REST /api/v1 → Fastify (Node) → Postgres
                                                              → RustFS (S3 API)
```

- Contract: `api-spec/openapi.yaml`. Frontend uses a typed client (`openapi-typescript` + `openapi-fetch`).
- Go and Python backends later: same spec, same DB, same E2E tests.

## API conventions

- Base path `/api/v1`.
- Public: lookup by slug, published content only. Admin: `/admin/*`, lookup by id, JWT required.
- Errors: RFC 7807. Pagination: `page` / `pageSize` → `{ items, total, page, pageSize }`.
- JSON camelCase, DB snake_case, dates ISO 8601 UTC.
- Auth: `POST /auth/login`, `POST /auth/refresh`, `POST /auth/logout`, `GET /auth/me`.
- Image upload: multipart `POST /admin/projects/{id}/images`; backend stores the file in S3 storage (RustFS in dev).

## Auth

JWT (HS256) in httpOnly cookies. Access 15 min, refresh 7 days with rotation and reuse detection. Rate-limited login. Admin created by seed.

## Stack

| Layer    | Tools                                                                               |
| -------- | ----------------------------------------------------------------------------------- |
| Frontend | React, TanStack Start, Mantine, CSS Modules, `@mantine/carousel`                    |
| Backend  | Fastify, TypeScript, zod, Prisma (read-only schema), pino                           |
| DB       | PostgreSQL, dbmate                                                                  |
| Storage  | RustFS in dev (S3 API; R2 or S3 in prod via config only)                            |
| Tests    | Vitest (unit + integration), shared E2E in `/tests/e2e`, 1–2 Playwright smoke flows |
| Tooling  | pnpm workspaces, Node 26 LTS, oxlint, oxfmt or Prettier, `tsc --noEmit`             |

## Environments

| Env        | Run                                                           | DB                              |
| ---------- | ------------------------------------------------------------- | ------------------------------- |
| dev        | `pnpm dev` (Postgres + RustFS in Docker, app with hot reload) | `designer_dev`, sample data     |
| test       | automatic in test runs and CI                                 | `designer_test`, reset each run |
| local prod | `pnpm prod:up` (prod images, Caddy HTTPS, non-root)           | `designer_prod`, admin only     |

Config from env vars, validated by zod at startup. Only `.env.example` is committed.

## Production basics

JSON logs with request IDs and rotation, `/health` and `/ready`, graceful shutdown, security headers, restricted CORS, no stack traces in prod.

## Git and CI

`main` protected, feature branches + PRs. CI: lint, format check, type check, migrations on clean DB, unit/integration tests, shared E2E, smoke test (`/health` → 200).

## Build order

1. Monorepo skeleton, Docker Compose, CI, `/health` smoke test
2. DB migrations and seed
3. OpenAPI spec
4. Fastify: config, logs, errors, auth
5. Fastify: projects, images, tips
6. Frontend: public pages with SSR and SEO
7. Frontend: admin panel
8. E2E + Playwright, local prod with Caddy
