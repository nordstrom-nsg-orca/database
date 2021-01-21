CREATE TABLE orca.page(
	id serial primary key,
	path character varying NOT NULL UNIQUE,
	title character varying NOT NULL
)
CREATE TABLE orca.user_page_permission (
	id serial primary key,
	user_id integer REFERENCES orca.user(id),
	page_id integer REFERENCES orca.page(id),
	write boolean not null
);

CREATE TABLE orca.group_page_permission (
	id serial primary key,
	group_id integer REFERENCES orca.group(id),
	page_id integer REFERENCES orca.page(id),
	write boolean not null
);

CREATE VIEW orca.user_page_permission_view AS
SELECT p.path, p.title,
	   u.write, u.user_id
FROM (orca.page p JOIN orca.user_page_permission u on (p.id = u.page_id));

CREATE VIEW orca.group_page_permission_view AS
SELECT p.path, p.title,
	   g.write, g.group_id
FROM (orca.page p JOIN orca.group_page_permission g on (p.id = g.page_id));


INSERT INTO orca.page(path, title) VALUES ('/schemas/*', 'Edit Schemas');
INSERT INTO orca.group (name) VALUES ('tchnsg');
INSERT INTO orca.user(username, password) VALUES ('admin', MD5('iwhal3b3back'))
INSERT INTO orca.user_page_permission (user_id, page_id, write) VALUES
((SELECT id from orca.user where username = 'admin'), 1, true);
INSERT INTO orca.group_page_permission (group_id, page_id, write) VALUES
((SELECT id from orca.group where name = 'tchnsg'), 1, true);
