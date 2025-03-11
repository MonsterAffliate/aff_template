#!/bin/bash
set -e

# Environment variables (set by workflow)
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
SUPERUSER=${SUPERUSER}
SUPERUSER_PASSWORD=${SUPERUSER_PASSWORD}

# Debug: Print environment variables to verify
echo "DEBUG: DB_NAME=$DB_NAME"
echo "DEBUG: DB_USER=$DB_USER"
echo "DEBUG: DB_PASSWORD=$DB_PASSWORD"
echo "DEBUG: SUPERUSER=$SUPERUSER"
echo "DEBUG: SUPERUSER_PASSWORD=$SUPERUSER_PASSWORD"

# Create a temporary .pgpass file
echo "localhost:5432:*:$SUPERUSER:$SUPERUSER_PASSWORD" > ~/.pgpass
chmod 600 ~/.pgpass

# Check if database exists, create if not
if ! psql -h localhost -U "$SUPERUSER" -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1; then
  echo "Creating database: $DB_NAME"
  psql -h localhost -U "$SUPERUSER" -d postgres -c "CREATE DATABASE $DB_NAME;"
fi

# Check if user exists, create if not
if ! psql -h localhost -U "$SUPERUSER" -d postgres -tc "SELECT 1 FROM pg_roles WHERE rolname = '$DB_USER'" | grep -q 1; then
  echo "Creating user: $DB_USER"
  psql -h localhost -U "$SUPERUSER" -d postgres -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"
fi

# Grant database-level privileges
echo "Granting privileges to $DB_USER on $DB_NAME"
psql -h localhost -U "$SUPERUSER" -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

# Grant schema-level privileges on public schema
echo "Granting USAGE and CREATE on public schema to $DB_USER"
psql -h localhost -U "$SUPERUSER" -d "$DB_NAME" -c "GRANT USAGE, CREATE ON SCHEMA public TO $DB_USER;"

# Clean up .pgpass file
rm -f ~/.pgpass