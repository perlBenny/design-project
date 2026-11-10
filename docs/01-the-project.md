# 1. The project

## What we build

A website for an interior designer. Visitors see finished projects and read design tips.
The designer manages the content in an admin panel.

- **Public site:** home, projects, a page per project, tips grouped by category, contact links.
- **Admin panel** (at `/admin`): add and edit projects, tips and images.
- **Hebrew and RTL.** The whole site reads right to left.

## Why SEO comes first

A designer gets clients from Google. So pages render on the server (SSR), every page has a title,
a meta description (≤160 characters) and clean URLs (slugs), and every image needs alt text.
Some of these rules live in the database, so bad data cannot even be saved. See [Database](05-database.md).

## Why it is also a learning project

The goal is to learn how a real product is built, not only to ship a site:

- One API contract (OpenAPI), **three backends** (Node first, then Go and Python), all tested by the same E2E suite.
- One database schema owned by SQL migrations, not by any backend.
- Real workflow: issues, branches, PRs, required CI checks, reviews.

## Not in scope (for now)

- Cloud hosting. Everything runs locally: dev, test and a "local prod" behind Caddy.
- A contact form. Contact is static links (phone, WhatsApp, email, Instagram).
