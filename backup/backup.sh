#!/usr/bin/env bash
export PGPASSWORD=password
pg_dumpall -h localhost -p 5433 --clean -U mochidb_owner --database=mochidb > mochidb.backup
tar -cvf  archive/"mochidb.backup-$(date +"%Y%m%dT%H%M").gz" mochidb.backup 
