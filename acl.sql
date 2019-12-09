CREATE TABLE access_list(
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);

CREATE TABLE access_item(
    id SERIAL PRIMARY KEY,
    list_id INTEGER REFERENCES access_list(id),
    subnet VARCHAR NOT NULL,
    description VARCHAR
);

CREATE OR REPLACE VIEW acl_view
AS
SELECT  l.name,
        i.subnet,
        i.description
FROM access_item i
JOIN access_list l ON i.list_id = l.id;