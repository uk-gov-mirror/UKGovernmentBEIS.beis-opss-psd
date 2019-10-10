#!/usr/bin/env bash
set -ex

# Create the database and user required by Keycloak
psql --username "$POSTGRES_USER" <<-EOSQL
  CREATE DATABASE $KEYCLOAK_DATABASE;
  CREATE USER $KEYCLOAK_DATABASE_USERNAME WITH ENCRYPTED PASSWORD '$KEYCLOAK_DATABASE_PASSWORD';
  GRANT ALL PRIVILEGES ON DATABASE $KEYCLOAK_DATABASE TO $KEYCLOAK_DATABASE_USERNAME;
EOSQL
