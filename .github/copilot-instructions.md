# Instructions for AI agents

Portfolio site for an interior designer (Hebrew, RTL, SEO-first). Learning project with production quality.
Read `docs/README.md` first, then `docs/SPEC.md` for the full spec.

## Rules

- **A PR is not done until the book is updated.** Follow `.github/skills/docs-book/SKILL.md`.
  The `docs` CI check enforces this. Use the `no-docs` label only for changes with nothing to explain.
- `main` is protected. Work on a `feature/*` branch, one PR per issue, with a "Closes" line and the issue number in the PR body.
- The DB schema lives only in `db/migrations` (dbmate, plain SQL). Never edit `db/schema.sql` by hand.
  Backends never change the schema (Prisma uses `db pull` only).
- New DB rule → add a test in `db/tests/constraints.sql`.
- Before pushing: `pnpm check` must pass.
- Never load `.env*` files into the shell (`set -a`): Docker Compose prefers shell variables.
- Never write secrets in code, docs or commit messages.

## Expert knowledge (Trove)

If Trove is installed (`trove` on PATH), before designing DB, auth/security, SEO, UI or reviewing a PR,
search the Trove library; the books on `.trove/shelf.json` come first. Cite book and page in your answer.
Our own rules (this file, `docs/`) win over a book; if they disagree, say so.
See `docs/11-ai-knowledge.md`.
