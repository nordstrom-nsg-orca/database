CREATE TABLE access_list(
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);

CREATE TABLE access_item(
    id SERIAL PRIMARY KEY,
    list_id INTEGER REFERENCES access_list(id) NOT NULL,
    subnet VARCHAR NOT NULL,
    description VARCHAR
);

CREATE TABLE test(
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL
);

CREATE OR REPLACE VIEW acl_view
AS
SELECT  l.name,
        i.subnet,
        i.description
FROM access_item i
JOIN access_list l ON i.list_id = l.id;

CREATE OR REPLACE VIEW acl_view_json
AS
SELECT json_build_object(
    'parentheaders', (
        SELECT array_agg(columns.column_name) AS array_agg
        FROM information_schema.columns
        WHERE columns.table_name = 'access_list' AND
            columns.column_name <> 'id'
    ),
    'headers', ( 
        SELECT array_agg(columns.column_name) AS array_agg
        FROM information_schema.columns
        WHERE columns.table_name = 'access_item' AND
            (columns.column_name <> ALL (ARRAY['id', 'list_id']))
        ),
    'data', (
        SELECT json_agg(t.*) AS json_agg
        FROM (
            SELECT l.id, l.name, json_agg(to_jsonb(i.*) - 'list_id') AS rows
            FROM access_list l
            JOIN access_item i ON i.list_id = l.id
            GROUP BY l.name, l.id
        ) t)
) AS results;


CREATE TABLE server_type(
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
);

CREATE TABLE server_item(
    id SERIAL PRIMARY KEY,
    type_id INTEGER REFERENCES server_type(id) NOT NULL,
    ip VARCHAR NOT NULL,
    tag VARCHAR
);
