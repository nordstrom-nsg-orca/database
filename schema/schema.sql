CREATE TABLE orca.schema (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    schema JSONB NOT NULL
);

INSERT INTO orca.schema VALUES
(1, 'schema', '{"id":"schema","$schema":"http://json-schema.org/draft-07/schema#","title":"schema to create a schema","type":"object","required":["name","properties"],"properties":{"name":{"type":"string"},"properties":{"$ref":"#/definitions/properties"}},"additionalProperties":false,"definitions":{"properties":{"type":"array","items":{"type":"object","oneOf":[{"required":["name","properties","type"],"properties":{"name":{"type":"string"},"required":{"type":"boolean"},"type":{"const":"object"},"properties":{"$ref":"#/definitions/properties"}},"additionalProperties":false},{"required":["name","type"],"properties":{"name":{"type":"string"},"required":{"type":"boolean"},"type":{"enum":["string","integer","boolean","number"]}},"additionalProperties":false},{"required":["name","type","items"],"properties":{"name":{"type":"string"},"required":{"type":"boolean"},"type":{"const":"array"},"items":{"$ref":"#/definitions/items"}},"additionalProperties":false}]}},"items":{"type":"object","oneOf":[{"required":["type"],"properties":{"type":{"enum":["string","integer","boolean","number"]}}},{"required":["type","properties"],"properties":{"type":{"const":"object"},"properties":{"$ref":"#/definitions/properties"}}},{"required":["type","items"],"properties":{"type":{"const":"array"},"items":{"$ref":"#/definitions/items"}}}]}}}');

CREATE TABLE orca.schemaItem (
	id SERIAL PRIMARY KEY,
	schemaId INTEGER REFERENCES orca.schema(id) NOT NULL,
	data JSONB NOT NULL
);