#!/usr/bin/env bash
export PGPASSWORD=password
pg_dumpall -h localhost -U mochidb_owner --clean --database=mochidb > mochidb.backup
tar -cvf  archive/"mochidb.backup-$(date +"%Y%m%dT%H%M").gz" mochidb.backup 
