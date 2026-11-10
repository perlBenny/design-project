# 2. Architecture

## The big picture

```text
Browser ──► Frontend (TanStack Start, SSR) ──► Backend API (/api/v1) ──► Postgres
                                                     │
                                                     └──► S3 storage (RustFS) ◄── images
```

Every arrow is a clear contract, so each part can be replaced alone.

## The parts

| Part          | Tech                                           | Status  |
| ------------- | ---------------------------------------------- | ------- |
| Frontend      | React 19, TanStack Start, Mantine, CSS Modules | Planned |
| API contract  | OpenAPI (`api-spec/openapi.yaml`)              | Planned |
| Main backend  | Node, Fastify, Prisma, zod                     | Planned |
| More backends | Go, Python (same contract)                     | Planned |
| Database      | Postgres 18, migrations with dbmate            | Done    |
| File storage  | RustFS (S3 API)                                | Done    |
| Proxy         | Caddy (local prod only)                        | Planned |

## Why one contract and many backends

The OpenAPI file is the "law". The frontend and the E2E tests talk only to the contract.
If the Go backend passes the same E2E tests as the Node one, it is a drop-in replacement.

## Why the database owns its schema

Many tools (Prisma, ORMs in Go and Python) want to own the schema. If each backend did that,
three backends would fight over one DB. So the schema is plain SQL in `db/migrations`,
and the backends only **read** it (Prisma uses `db pull`). See [Database](05-database.md).

## Auth in one paragraph (planned)

Login returns two JWTs in `httpOnly` cookies: an access token (15 minutes) and a refresh
token (7 days). Every refresh gives a new refresh token (rotation). If an old one is used again,
the whole family is revoked (reuse detection). Roles: `admin` and `editor`, with permissions.
The tables for this already exist.

## API style (planned)

REST under `/api/v1`. Errors follow [RFC 7807](https://www.rfc-editor.org/rfc/rfc7807) (`application/problem+json`).
