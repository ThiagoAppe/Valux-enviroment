-- Apply once to databases created before authentication was introduced.
-- The application does not execute schema changes automatically.
ALTER TABLE users
ADD COLUMN IF NOT EXISTS last_token_jti varchar(36);
