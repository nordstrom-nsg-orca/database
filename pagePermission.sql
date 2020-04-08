CREATE TABLE orca.page (
	id serial primary key,
	tab character varying NOT NULL,
	url character varying NOT NULL,
	loadUrl character varying NOT NULL,
	crudUrl character varying NOT NULL,
	parentId character varying NOT NULL,
	name character varying NOT NULL,
	title character varying NOT NULL
);
INSERT INTO orca.page (tab, url, loadUrl, crudUrl, parentId, name, title) VALUES
	('data', '/acl', '/tables/acl_view_json', '/tables/access_item', 'list_id', 'Network Data', 'ACL Management'),
	('data', '/server', '/tables/server_view_json', '/tables/server_item', 'type_id', 'Network Data', 'Server Management'),
	('data', '/.*', '', '', '', '', ''),
	('admin', '/permission', '', '', '', '', ''),
	('admin', '/page', '', '', '', '', ''),
	('admin', '/.*', '', '', '', '', ''),
	('', '.*', '', '', '', '', '');
SELECT * FROM orca.page;

CREATE TABLE orca.user_page_permission (
	id serial primary key,
	user_id integer REFERENCES orca.user(id),
	page_id integer REFERENCES orca.page(id),
	write boolean not null
);

INSERT INTO orca.user_page_permission (user_id, page_id, write) VALUES
((SELECT id from orca.user where username = 'admin'), (SELECT id from orca.page where url = '.*'), true);

SELECT page_id, write FROM orca.user_page_permission where user_id = (SELECT id from orca.user where username = 'admin');

CREATE VIEW orca.user_page_permission_view AS
SELECT p.tab, p.url,
	   u.write, u.user_id
FROM (orca.page p JOIN orca.user_page_permission u on (p.id = u.page_id))

SELECT * FROM orca.user_page_permission_view;

CREATE TABLE orca.group (
	id serial primary key,
	name character varying unique not null
);

INSERT INTO orca.group (name) VALUES ('tchnsg');

CREATE TABLE orca.group_page_permission (
	id serial primary key,
	group_id integer REFERENCES orca.group(id),
	page_id integer REFERENCES orca.page(id),
	write boolean not null
);

INSERT INTO orca.group_page_permission (group_id, page_id, write) VALUES
((SELECT id from orca.group where name = 'tchnsg'), (SELECT id from orca.page where tab = 'data' and url = '/.*' ), true);

CREATE VIEW orca.group_page_permission_view AS
SELECT p.tab, p.url,
	   g.write, g.group_id
FROM (orca.page p JOIN orca.group_page_permission g on (p.id = g.page_id));

SELECT * FROM orca.group_page_permission_view;

SELECT * FROM orca.user_page_permission_view WHERE user_id = (SELECT id FROM orca.user WHERE username = 'admin');
