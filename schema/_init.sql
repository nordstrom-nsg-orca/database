DROP SCHEMA orca CASCADE;

CREATE SCHEMA orca;

CREATE ROLE readaccess;
GRANT USAGE ON SCHEMA orca TO readaccess;
GRANT SELECT ON ALL TABLES IN SCHEMA orca TO readaccess;
ALTER DEFAULT PRIVILEGES IN SCHEMA orca GRANT SELECT ON TABLES TO readaccess;

CREATE USER nsgorca WITH PASSWORD 'readonly'; 
GRANT readaccess TO nsgorca;
