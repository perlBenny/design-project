# 10. FAQ

**Can I change a table from Prisma?**
No. Write a migration in `db/migrations` (`pnpm db:new ...`). Prisma only reads the schema (`db pull`).

**I edited a migration that already ran. Why doesn't it apply?**
dbmate runs each file once. Locally, run `pnpm db:reset`. If the migration is already on `main`, write a new one.

**CI says `db/schema.sql` is not up to date.**
Run `pnpm db:migrate` and commit `db/schema.sql`.

**CI `docs` check failed.**
Your PR changed code but not the book. Update the right chapter, or add the `no-docs` label if there is truly nothing to explain.

**Where do I put a new setting?**
In `.env.example` with a safe dev value, and in your own `.env.dev`. Never commit `.env.dev`.

**My container uses an old password.**
Probably a variable left in your shell. Open a new terminal. See [Lessons](09-lessons.md).

**How do I add a DB rule?**
Add it in a migration, then add a test in `db/tests/constraints.sql` and run `pnpm db:test`.

**Where is the full spec?**
[SPEC.md](SPEC.md).
