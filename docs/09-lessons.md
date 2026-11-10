# 9. Lessons

Things that broke, how we found them, and what we changed. This is the part nobody else writes down.

## MinIO images disappeared

- **What happened:** the MinIO Docker image we planned to use was no longer published.
- **Fix:** switched to RustFS, which has the same S3 API.
- **Lesson:** depend on the protocol (S3), not on one product.

## Node 26 has no corepack

- **What happened:** `corepack enable` failed; Node 26 no longer ships it.
- **Fix:** `npm i -g pnpm`. The exact version is pinned in `package.json` (`packageManager`).

## oxlint failed on an empty repo

- **What happened:** with no source files yet, oxlint exited with an error.
- **Fix:** `--no-error-on-unmatched-pattern`.

## Postgres 18 changed its data path

- **What happened:** the old volume path `/var/lib/postgresql/data` did not work with Postgres 18.
- **Fix:** mount the volume at `/var/lib/postgresql`.

## A race in CI

- **What happened:** CI sometimes checked the bucket before `storage-init` finished.
- **Fix:** `docker wait` on the container, then check its exit code.
- **Lesson:** never "sleep and hope"; wait for a real signal.

## The schema diff failed on every Postgres patch

- **What happened:** `db/schema.sql` includes a `-- Dumped from database version` line, which changes with the image.
- **Fix:** the CI diff ignores lines that start with `-- Dumped`.

## A password broke the DB URL (found in code review)

- **What happened:** a password like `loc#al/pa@ss` inside `DATABASE_URL` made dbmate fail with `invalid port`.
- **Fix:** pass the password in `PGPASSWORD`, keep the URL without it.
- **Lesson:** review comments are worth testing, not just answering.

## The shell beat the `.env` file

- **What happened:** after `set -a; source .env.dev`, old values stayed in the shell. Docker Compose
  prefers shell variables over `--env-file`, so containers got the wrong user and password.
- **Fix:** never load `.env` files into the shell. Open a new terminal if you did.

## A token in a dotfile

- **What happened:** a GitHub token was stored in plain text in `~/.bashrc` and showed up in terminal output.
- **Fix:** removed it from the file, revoke it on GitHub, and use `gh auth login` (system keyring) instead.
- **Lesson:** secrets go in a keyring or a secret store, never in files that are printed or committed.

## The book found what our review missed

- **What happened:** we checked the schema against a Postgres best-practices book. `refresh_tokens.replaced_by`
  is a foreign key with no index. Postgres does not index foreign keys for you, so a delete would scan the table.
- **Fix:** a new migration adds the index, and a DB test now fails if any foreign key has no index.
- **Lesson:** turn a book rule into a test. A rule only in a document is forgotten; a test is not.

## The lint rule that was out of date

- **What happened:** oxlint warned "React must be in scope" on every JSX line.
- **Why:** that rule is for the old JSX transform. With `"jsx": "react-jsx"` React is imported automatically.
- **Fix:** turned off `react/react-in-jsx-scope` in `.oxlintrc.json`.

## pnpm refused a brand-new package

- **What happened:** installing vite 8.3.7 (out for less than a day) made pnpm add `minimumReleaseAgeExclude` entries to `pnpm-workspace.yaml`.
- **Why:** pnpm waits before it trusts a new release. Many supply-chain attacks are hijacked releases caught within hours.
- **Fix:** we did not weaken the rule. We allowed `^8.3.0` and let pnpm pick 8.3.6, which is old enough.
- **Lesson:** if a tool tries to switch off a safety check for you, read the diff before you commit it.

## VS Code flagged valid CSS

- **What happened:** `@media (max-width: $mantine-breakpoint-sm)` showed "term expected" in VS Code, but the build was fine.
- **Why:** VS Code checked the file as plain CSS. `$variables` are a PostCSS feature.
- **Fix:** `.vscode/settings.json` opens `.css` as PostCSS, and `.vscode/extensions.json` recommends the PostCSS extension.
- **Lesson:** an editor error is not a build error. Check `pnpm build` before changing working code.
