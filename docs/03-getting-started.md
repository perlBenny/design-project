# 3. Getting started

## What you need

| Tool           | Why                                 | Link                                 |
| -------------- | ----------------------------------- | ------------------------------------ |
| Node 26 LTS    | Runs the tooling (see `.nvmrc`)     | [nodejs.org](https://nodejs.org)     |
| pnpm           | Package manager for the monorepo    | [pnpm.io](https://pnpm.io)           |
| Docker Desktop | Runs Postgres, storage and DB tools | [docker.com](https://www.docker.com) |

Node 26 does not ship corepack, so install pnpm with `npm i -g pnpm`.

## Run it

```bash
cp .env.example .env.dev   # local settings; never commit this file
pnpm install
pnpm dev                   # starts Docker services, migrates, seeds
```

`pnpm dev` = `infra:up` → `db:migrate` → `db:seed` → the `dev` script of every package.

## Check it works

| What            | Where                                                                                    |
| --------------- | ---------------------------------------------------------------------------------------- |
| Postgres        | `localhost:5432`, DB `designer_dev`, user `admin`, password `password` (dev and CI only) |
| Storage API     | `http://localhost:9000`                                                                  |
| Storage console | `http://localhost:9001`                                                                  |
| DB rule tests   | `pnpm db:test` — every line should say `PASS`                                            |
| Browse the DB   | `pnpm db:ui`, then `http://localhost:5050`                                               |

## Daily commands

| Command                      | What it does                                                  |
| ---------------------------- | ------------------------------------------------------------- |
| `pnpm check`                 | Lint, format check, typecheck, tests. Run before every push.  |
| `pnpm format`                | Fix formatting                                                |
| `pnpm infra:down`            | Stop Docker services (data is kept)                           |
| `pnpm db:reset`              | Rebuild the dev DB from zero                                  |
| `pnpm --filter frontend dev` | Only the website, on http://localhost:3000 (no Docker needed) |

## Warning: don't load `.env` into the shell

Don't run `set -a; source .env.dev`. Docker Compose prefers shell variables over the env file,
so old values in your shell silently win. See [Lessons](09-lessons.md).
