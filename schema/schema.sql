
CREATE TABLE orca.schema (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    data JSONB,
    schema JSONB NOT NULL,
    core BOOL NOT NULL DEFAULT false
);

--- INSERT INTO orca.schema (name, schema) VALUES
--- ('schema', '{"id":"schema","$schema":"http://json-schema.org/draft-07/schema#","title":"schema to create a schema","type":"object","required":["name","properties"],"properties":{"name":{"type":"string"},"properties":{"$ref":"#/definitions/properties"}},"additionalProperties":false,"definitions":{"properties":{"type":"array","items":{"type":"object","oneOf":[{"required":["name","properties","type"],"properties":{"name":{"type":"string"},"required":{"type":"boolean"},"type":{"const":"object"},"properties":{"$ref":"#/definitions/properties"}},"additionalProperties":false},{"required":["name","type"],"properties":{"name":{"type":"string"},"required":{"type":"boolean"},"type":{"enum":["string","integer","boolean","number"]}},"additionalProperties":false},{"required":["name","type","items"],"properties":{"name":{"type":"string"},"required":{"type":"boolean"},"type":{"const":"array"},"items":{"$ref":"#/definitions/items"}},"additionalProperties":false}]}},"items":{"type":"object","oneOf":[{"required":["type"],"properties":{"type":{"enum":["string","integer","boolean","number"]}}},{"required":["type","properties"],"properties":{"type":{"const":"object"},"properties":{"$ref":"#/definitions/properties"}}},{"required":["type","items"],"properties":{"type":{"const":"array"},"items":{"$ref":"#/definitions/items"}}}]}}}');

INSERT INTO orca.schema (name, core, schema) VALUES
  ('schema', true, '{"type":"object","required":["name","properties"],"order":["name","properties"],"properties":{"name":{"type":"string"},"properties":{"$ref":"#/definitions/properties"}},"definitions":{"type":{"type":"string","enum":["string","boolean","integer","array","object"]},"properties":{"type":"array","items":{"type":"object","required":["name","type"],"order":["name","type","required","properties","items"],"properties":{"name":{"type":"string"},"type":{"$ref":"#/definitions/type"},"properties":{"onlyIf":{"type":"object"},"$ref":"#/definitions/properties"},"items":{"onlyIf":{"type":"array"},"$ref":"#/definitions/items"},"required":{"type":"boolean"}},"allOf":[{"if":{"properties":{"type":{"const":"object"}}},"then":{"required":["name","properties","type"]}}]}},"items":{"type":"object","required":["type"],"order":["type","properties","items"],"properties":{"type":{"$ref":"#/definitions/type"},"properties":{"onlyIf":{"type":"object"},"$ref":"#/definitions/properties"},"items":{"$ref":"#/definitions/items","onlyIf":{"type":"array"}}}}}}');

CREATE TABLE orca.schemaItem (
	id SERIAL PRIMARY KEY,
	schemaId INTEGER REFERENCES orca.schema(id) NOT NULL,
	data JSONB NOT NULL
);
