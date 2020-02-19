CREATE SCHEMA orca;
CREATE ROLE readaccess;
GRANT USAGE ON SCHEMA orca TO readaccess;
GRANT SELECT ON ALL TABLES IN SCHEMA orca TO readaccess;
ALTER DEFAULT PRIVILEGES IN SCHEMA orca GRANT SELECT ON TABLES TO readaccess;

CREATE USER nsgorca WITH PASSWORD #REDACTED;
GRANT readaccess TO nsgorca;

CREATE EXTENSION pgcrypto;
CREATE TABLE orca.user(
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL
);

CREATE TABLE orca.api_test(
  id SERIAL PRIMARY KEY,
  required_column VARCHAR NOT NULL,
  optional_column VARCHAR
);

CREATE TABLE orca.access_list(
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);

CREATE TABLE orca.access_item(
    id SERIAL PRIMARY KEY,
    list_id INTEGER REFERENCES orca.access_list(id) NOT NULL,
    subnet VARCHAR NOT NULL,
    description VARCHAR,
    delete BOOLEAN NOT NULL DEFAULT False
);

CREATE OR REPLACE VIEW orca.acl_view
AS
SELECT  l.name,
        i.subnet,
        i.description
FROM orca.access_item i
JOIN orca.access_list l ON i.list_id = l.id;

CREATE OR REPLACE VIEW orca.acl_view_json
AS
SELECT json_build_object(
    'parentheaders', (
        SELECT array_agg(columns.column_name) AS array_agg
        FROM information_schema.columns
        WHERE columns.table_name = 'access_list' AND
            columns.column_name <> 'id'
    ),
    'headers', (
        SELECT json_agg(t.*) AS json_agg
        FROM (
            SELECT columns.column_name, columns.data_type
            FROM information_schema.columns
            WHERE columns.table_name = 'access_item' AND
                (columns.column_name <> ALL (ARRAY['id', 'list_id']))
        ) t
    ),
    'data', (
        SELECT json_agg(t.*) AS json_agg
        FROM (
            SELECT l.id, l.name, json_agg(to_jsonb(i.*) - 'list_id') AS rows
            FROM orca.access_list l
            JOIN orca.access_item i ON i.list_id = l.id
            GROUP BY l.name, l.id
        ) t)
) AS results;

---- ---- ---- ---- ---- ---- ---- ----
--- SERVER
---- ---- ---- ---- ---- ---- ---- ----
CREATE TABLE orca.server_type(
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);

CREATE TABLE orca.server_item(
    id SERIAL PRIMARY KEY,
    type_id INTEGER REFERENCES orca.server_type(id) NOT NULL,
    ip VARCHAR NOT NULL,
    tag VARCHAR
);

CREATE OR REPLACE VIEW orca.server_view
AS
SELECT  t.name,
        i.ip,
        i.tag
FROM orca.server_item i
JOIN orca.server_type t ON i.type_id = l.id;

CREATE OR REPLACE VIEW orca.server_view_json
AS
SELECT json_build_object(
    'parentheaders', (
        SELECT array_agg(columns.column_name) AS array_agg
        FROM information_schema.columns
        WHERE columns.table_name = 'server_type' AND
            columns.column_name <> 'id'
    ),
    'headers', (
        SELECT json_agg(t.*) AS json_agg
        FROM (
            SELECT columns.column_name, columns.data_type
            FROM information_schema.columns
            WHERE columns.table_name = 'server_item' AND
                (columns.column_name <> ALL (ARRAY['id', 'type_id']))
        ) t
    ),
    'data', (
        SELECT json_agg(t.*) AS json_agg
        FROM (
            SELECT t.id, t.name, json_agg(to_jsonb(i.*) - 'type_id') AS rows
            FROM orca.server_type t
            JOIN orca.server_item i ON i.type_id = t.id
            GROUP BY t.name, t.id
        ) t)
) AS results;

---- ---- ---- ---- ---- ---- ---- ----
--- ANSIBLE VIEW
---- ---- ---- ---- ---- ---- ---- ----

CREATE OR REPLACE VIEW orca.module_view
AS
SELECT json_build_object(
    'acl', (
        SELECT json_agg(t.*) AS json_agg
        FROM (
            SELECT l.name, json_agg(to_jsonb(i.subnet)) AS rows
            FROM orca.access_list l
            JOIN orca.access_item i ON i.list_id = l.id
            GROUP BY l.name
        ) t),
    'server', (
        SELECT json_agg(t.*) AS json_agg
        FROM (
            SELECT t.name, json_agg(to_jsonb(i.*) - 'id' - 'type_id') AS rows
            FROM orca.server_type t
            JOIN orca.server_item i ON i.type_id = t.id
            GROUP BY t.name
        ) t)
) AS results;
