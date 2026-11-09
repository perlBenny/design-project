# 11. AI knowledge (Trove)

## Why

Every AI agent knows the same average things. [Trove](https://heytrove.ai) gives our agents a small library of
expert books, and every answer cites the book and page, so you can check it.

## How it fits with the rest

| Layer                             | Holds                                | Lives in                    |
| --------------------------------- | ------------------------------------ | --------------------------- |
| `.github/copilot-instructions.md` | Our rules                            | Git                         |
| `.github/skills/`                 | How we do repeated tasks             | Git                         |
| `docs/` (this book)               | Our decisions and lessons            | Git                         |
| **Trove shelf**                   | Outside expert knowledge (the "why") | Trove + `.trove/shelf.json` |

Our own rules always win. A book is advice; if it disagrees with a decision, the agent must say so,
and we either keep our decision or change it in [Decisions](08-decisions.md).

We did **not** upload this book to Trove. It is already in the repo, and a copy would go stale.

## The project shelf

`.trove/shelf.json` lists the books the agent reads first in this repo. It is committed, so every
teammate and agent gets the same shelf.

| Book                                   | Why we need it                                     |
| -------------------------------------- | -------------------------------------------------- |
| SEO for AI Agents                      | SEO is the main goal of the site                   |
| Supabase PostgreSQL Best Practices     | Schema, indexes and constraints in `db/migrations` |
| Web Application Security for AI Agents | JWT cookies, refresh rotation, RBAC, uploads       |
| UI/UX Design Principles for AI Agents  | Public site, admin panel, accessibility            |
| Code Review for AI Agents              | One checklist for reviewing PRs                    |

## Setup (one time, per developer)

```bash
curl -fsSL https://heytrove.ai/install.sh | DO_NOT_TRACK=1 sh   # Git Bash; signs in through the browser
trove setup --enable github-copilot                             # if Copilot was not detected
```

This adds the `trove` command and, in `~/.copilot`, a Trove skill, four sub-agents (librarian, reader,
book writer, enricher) and a session hook. VS Code Copilot reads that folder. Nothing in the repo
contains a key; sign-in is stored on your machine. `DO_NOT_TRACK=1` turns off install stats.

## How to use it

Ask explicitly. Automatic lookup is not reliable yet.

```text
Search my Trove library for how to store refresh tokens safely.
```

The librarian picks books (shelf first), readers open the pages, and the answer cites them.

## Good at / falls short

- **Good at:** cited, expert answers; one library for every agent (Copilot, Claude, Cursor…); the shelf is shared through git.
- **Falls short:** external paid service (free plan: 5 items, 100 reads a month); needs sign-in per developer;
  CI does not use it; the marketplace has few books for some topics (no REST-API or Docker book found).
