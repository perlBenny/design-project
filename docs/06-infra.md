# 6. Infra (Docker)

## Why Docker for services

Everyone gets the same Postgres and storage versions with one command, and nothing is installed on your machine.
All services are in [`compose.yml`](../compose.yml) and read settings from `.env.dev`.

## Services

| Service        | Image           | Job                                                             |
| -------------- | --------------- | --------------------------------------------------------------- |
| `postgres`     | Postgres 18     | The database. Data is kept in the `pgdata` volume               |
| `storage`      | RustFS          | S3-compatible file storage for images (ports 9000, 9001)        |
| `storage-init` | aws-cli         | Runs once: creates the `designer-images` bucket, public read    |
| `dbmate`       | dbmate          | Migrations. Profile `tools`: runs only when called              |
| `seed`         | Postgres (psql) | Loads seed files and runs DB tests. Profile `tools`             |
| `pgadmin`      | pgAdmin 4       | Web UI for the DB, `localhost:5050`. Profile `ui`: `pnpm db:ui` |

## Health checks

`postgres` and `storage` have health checks. `docker compose up --wait` returns only when they are healthy,
so scripts never talk to a service that is still starting.

## Why RustFS and not MinIO

MinIO stopped publishing its free Docker images. [RustFS](https://rustfs.com) speaks the same S3 API,
so the code will work with AWS S3 or any S3 service later without changes.

## Passwords and the DB URL

The `dbmate` service gets the password in `PGPASSWORD`, not inside `DATABASE_URL`.
A password with `#`, `/` or `@` breaks a URL. See [Lessons](09-lessons.md).
