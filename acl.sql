CREATE TABLE acl_prefix(
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);

CREATE TABLE acl_item(
    id SERIAL PRIMARY KEY,
    prefix_id INTEGER REFERENCES acl_prefix(id),
    subnet VARCHAR NOT NULL,
    description VARCHAR,
);

CREATE OR REPLACE VIEW acl_view
AS
SELECT  p.name,
        i.subnet,
        i.description
FROM acl_item i
JOIN acl_prefix p ON i.id = p.id;