# 8. Decisions

Every choice has a cost. Each entry says what we chose, what else we considered, and the trade-off.

## pnpm workspaces (monorepo)

- **Chose:** one repo, pnpm workspaces. **Considered:** separate repos, npm workspaces.
- **Good at:** one PR can change the contract, a backend and the tests together. Fast, strict installs.
- **Falls short:** one CI runs for everything; needs care to keep packages independent.

## oxlint + Prettier

- **Chose:** [oxlint](https://oxc.rs) and [Prettier](https://prettier.io). **Considered:** ESLint, Biome, oxfmt.
- **Good at:** oxlint is very fast and needs almost no config. Prettier is the standard.
- **Falls short:** oxlint has fewer plugins than ESLint. oxfmt was still before 1.0.

## dbmate with plain SQL migrations

- **Chose:** [dbmate](https://github.com/amacneil/dbmate). **Considered:** Prisma Migrate, Flyway.
- **Good at:** language-neutral, so Node, Go and Python share one schema. Plain SQL, full Postgres power.
- **Falls short:** no auto-generated migrations; you write SQL by hand.

## UUID v7 IDs

- **Chose:** UUID v7. **Considered:** serial integers, UUID v4.
- **Good at:** IDs can't be guessed, and they sort by time, so indexes stay compact.
- **Falls short:** 16 bytes instead of 4–8; harder to read in logs.

## Rules in the DB, not only in code

- **Chose:** `check` constraints, partial indexes, triggers. **Considered:** validation only in the backend.
- **Good at:** three backends can't disagree; bad data can never be saved.
- **Falls short:** rules live in two places (DB and API validation).

## RustFS for storage

- **Chose:** [RustFS](https://rustfs.com). **Considered:** MinIO (images no longer published), local disk.
- **Good at:** real S3 API, same code works in the cloud later.
- **Falls short:** young project.

## JWT in httpOnly cookies

- **Chose:** short access + rotating refresh tokens in cookies. **Considered:** server sessions, tokens in localStorage.
- **Good at:** JavaScript can't read the cookie (safer against XSS); stateless API.
- **Falls short:** needs refresh logic and CSRF care.

## Docs as Markdown in the repo

- **Chose:** Markdown in `docs/`, read on GitHub. **Considered:** VitePress, Starlight.
- **Good at:** zero setup; lives next to the code; reviewed in the same PR.
- **Falls short:** no search or custom design. Can move to a docs site later with the same files.

## Trove for expert knowledge

- **Chose:** [Trove](https://heytrove.ai) with a committed project shelf. **Considered:** no external knowledge, copying best practices into skills.
- **Good at:** cited expert answers in every agent; the shelf is shared through git.
- **Falls short:** paid external service, sign-in per developer, not used in CI. See [AI knowledge](11-ai-knowledge.md).
