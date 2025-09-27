-- NOTE: change to your own passwords for production environments
\set pgpass `echo "$POSTGRES_PASSWORD"`

-- Set passwords for existing roles (they already exist from migrations)
ALTER ROLE authenticator WITH PASSWORD :'pgpass';
ALTER ROLE pgbouncer WITH PASSWORD :'pgpass';
ALTER ROLE supabase_auth_admin WITH PASSWORD :'pgpass';
ALTER ROLE supabase_functions_admin WITH PASSWORD :'pgpass';
ALTER ROLE supabase_storage_admin WITH PASSWORD :'pgpass';
ALTER ROLE supabase_admin WITH PASSWORD :'pgpass';

-- Ensure role grants are in place
GRANT anon TO authenticator;
GRANT service_role TO authenticator;
