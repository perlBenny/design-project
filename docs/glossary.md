# Glossary

| Term             | Meaning                                                                                      |
| ---------------- | -------------------------------------------------------------------------------------------- |
| Constraint       | A rule inside the DB (`check`, `unique`, `not null`) that rejects bad data                   |
| CI               | Continuous Integration: GitHub runs checks on every PR                                       |
| dbmate           | Tool that runs SQL migration files in order and records which ran                            |
| Idempotent       | Running it twice gives the same result as running it once                                    |
| JWT              | JSON Web Token: a signed token that says who the user is                                     |
| Migration        | A SQL file that changes the schema, with an `up` and a `down` part                           |
| Monorepo         | One repository with several packages (frontend, backends, tests)                             |
| OpenAPI          | A file format that describes a REST API: paths, inputs, outputs                              |
| Partial index    | An index on only some rows, e.g. "unique cover image per project"                            |
| RBAC             | Role-Based Access Control: users have roles, roles have permissions                          |
| Refresh rotation | Every refresh returns a new refresh token; the old one stops working                         |
| RFC 7807         | Standard JSON format for API errors (`problem+json`)                                         |
| RTL              | Right-to-left text direction (Hebrew)                                                        |
| S3               | Amazon's file storage API; many tools (RustFS) speak it                                      |
| Seed             | Starting data loaded into the DB (roles, sample content)                                     |
| SEO              | Search Engine Optimization: making pages easy for Google to find and show                    |
| Skill            | A Markdown file that teaches an AI agent how to do one task in this repo                     |
| Slug             | The URL part of a page, e.g. `modern-kitchen`                                                |
| SSR              | Server-Side Rendering: the server sends ready HTML, good for SEO                             |
| UUID v7          | A unique ID that starts with a timestamp, so new IDs sort last                               |
| Shelf            | A Trove list of books an agent reads first in one project (`.trove/shelf.json`)              |
| Trove            | A library of expert books that AI agents read and cite. See [chapter 11](11-ai-knowledge.md) |
| Hydration        | The browser takes server-rendered HTML and makes it interactive                              |
| Route tree       | The list of pages, generated from files in `frontend/src/routes`                             |
