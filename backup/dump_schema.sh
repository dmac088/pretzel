export PGPASSWORD=password
pg_dump -h localhost -U mochidb_owner --schema-only --clean --schema "mochi" --disable-dollar-quoting mochidb > ../../be/src/main/resources/database/mochi_schema.sql
pg_dump -h localhost -U security_owner --schema-only --clean --schema "security" --disable-dollar-quoting mochidb > ../../be/src/main/resources/database/security_schema.sql
