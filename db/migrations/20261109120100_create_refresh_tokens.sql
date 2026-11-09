-- migrate:up

-- Refresh tokens are stored as a hash, never as the raw token.
-- family_id groups all tokens created from one login: when an old (rotated)
-- token is reused, every token in its family is revoked.
create table refresh_tokens (
  id          uuid primary key default uuidv7(),
  user_id     uuid not null references users (id) on delete cascade,
  family_id   uuid not null,
  token_hash  text not null unique,
  expires_at  timestamptz not null,
  revoked_at  timestamptz,
  replaced_by uuid references refresh_tokens (id) on delete set null,
  created_at  timestamptz not null default now()
);

create index refresh_tokens_user_id_idx on refresh_tokens (user_id);
create index refresh_tokens_family_id_idx on refresh_tokens (family_id);
create index refresh_tokens_expires_at_idx on refresh_tokens (expires_at);

-- migrate:down

drop table refresh_tokens;
