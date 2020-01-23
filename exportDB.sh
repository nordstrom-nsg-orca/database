#!/bin/bash
chmod 0600 oldDB.pgpass
chmod 0600 newDB.pgpass
export PGPASSFILE=oldDB.pgpass
pg_dump -h nsg.clqzasuuu8wm.us-west-2.rds.amazonaws.com -d nsgdatabase -w -U nsg -f mydb2dump.sql
export PGPASSFILE=newDB.pgpass
psql -h nsgclouddb.clqzasuuu8wm.us-west-2.rds.amazonaws.com -d nsgCloudDB -w -U nsg < mydb2dump.sql
