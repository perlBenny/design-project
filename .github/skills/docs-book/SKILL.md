---
name: docs-book
description: Write or update the project book in docs/. Use whenever a PR changes code, infra, CI, the database or a decision, or when asked to explain part of the project.
---

# Docs book skill

The book in `docs/` explains the whole project to a developer who is new to it.
It is a learning book: it explains **why** before **how**.

## When to use

- Every PR that changes code, infra, CI, the DB or a decision. The `docs` CI check fails otherwise.
- When a new lesson was learned (a bug, a surprise, a tool that broke).

## Steps

1. Read `docs/README.md` (table of contents) and find the chapter(s) the change touches.
2. Read the changed files in the PR (`git diff main...HEAD --stat`, then the files).
3. Update the chapter. If no chapter fits, add a new numbered file and link it in `docs/README.md`.
4. A new decision goes to `08-decisions.md`. A new surprise or fix goes to `09-lessons.md`.
5. New terms go to `glossary.md`.
6. Check that every command you wrote really exists in `package.json` or `compose.yml`.
7. Run `pnpm format` and fix links.

## Style (inspired by heytrove.ai)

- **Short heading + one sentence of "why".** The reader should get the point from the headings alone.
- **Plain words.** Short sentences. No marketing. Explain a term the first time, or link to `glossary.md`.
- **Show, then explain.** A small real snippet from the repo, then 1–3 sentences about it.
- **Honest comparisons.** For each decision: what we chose, what else we considered, "good at" / "falls short".
- **Lessons.** Write what went wrong and how we found it, not only the fix.
- **Sources.** Link the official docs for every tool you mention.
- English. Markdown only. Tables for lists of commands or files.

## Don't

- Don't copy whole files into the book; link them (`../compose.yml`).
- Don't repeat `SPEC.md`; link it. SPEC is the reference, the book is the explanation.
- Don't write secrets or real values from `.env.dev`.
- Don't describe things that are not built yet as if they exist. Mark them **(planned)**.
