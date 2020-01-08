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
SELECT name, json_agg(i.*) as ips
FROM access_list l
JOIN access_item i ON i.list_id = l.id
GROUP BY name;
