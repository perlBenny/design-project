# The Design Project book

A portfolio site for an interior designer, built as a learning project with production quality.
This book explains **what** we built, **why** we chose each piece, and **what we learned** on the way.

> Read the chapters in order the first time. Later, use them as a reference.
> The full requirements live in [SPEC.md](SPEC.md). The book explains; the spec defines.

## Chapters

| #   | Chapter                                    | You will learn                                                |
| --- | ------------------------------------------ | ------------------------------------------------------------- |
| 1   | [The project](01-the-project.md)           | What we build, for whom, and the goals                        |
| 2   | [Architecture](02-architecture.md)         | The parts of the system and how they talk                     |
| 3   | [Getting started](03-getting-started.md)   | Run everything on your machine in a few minutes               |
| 4   | [Repo tour](04-repo-tour.md)               | Every folder and config file, and why it exists               |
| 5   | [Database](05-database.md)                 | Tables, rules, migrations, seed and DB tests                  |
| 6   | [Infra (Docker)](06-infra.md)              | Postgres and S3 storage in Docker Compose                     |
| 7   | [CI and workflow](07-ci.md)                | GitHub checks, branches, PRs and the "book rule"              |
| 8   | [Decisions](08-decisions.md)               | What we chose, what else we considered, good at / falls short |
| 9   | [Lessons](09-lessons.md)                   | Things that broke and what they taught us                     |
| 10  | [FAQ](10-faq.md)                           | Short answers to common questions                             |
| 11  | [AI knowledge (Trove)](11-ai-knowledge.md) | Expert books our AI agents read, and how to use them          |
| 12  | [Frontend](12-frontend.md)                 | How the website is built and how a page is rendered           |
| —   | [Glossary](glossary.md)                    | Every term in one place                                       |

## Status

| Part                  | Status                   |
| --------------------- | ------------------------ |
| Repo, tooling, Docker | Done                     |
| CI                    | Done                     |
| Database              | Done                     |
| API spec (OpenAPI)    | **Planned**              |
| Node backend          | **Planned**              |
| Frontend              | **Started** (hello page) |
| E2E tests, local prod | **Planned**              |

## How this book stays true

Every PR that changes the project must update this book. A CI check (`docs`) fails if code
changed but `docs/` did not. AI agents follow the [docs-book skill](../.github/skills/docs-book/SKILL.md),
so the style stays the same no matter who writes.
