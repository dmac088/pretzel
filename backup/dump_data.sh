export PGPASSWORD=password
pg_dump -h localhost -U mochidb_owner --data-only --inserts  --schema "mochi" mochidb > ~/projects/sorbet/src/test/resources/database/mochi_data.sql
pg_dump -h localhost -U security_owner --data-only --inserts  --schema "security" mochidb > ~/projects/sorbet/src/test/resources/database/security_data.sql
