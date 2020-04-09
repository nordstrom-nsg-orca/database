CREATE TABLE orca.user(
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL
);

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
	('admin', '/permission', '', '', '', '', ''),
	('admin', '/page', '', '', '', '', ''),
	('admin', '/.*', '', '', '', '', ''),
	('', '.*', '', '', '', '', '')
;

CREATE TABLE orca.user_page_permission (
	id serial primary key,
	user_id integer REFERENCES orca.user(id),
	page_id integer REFERENCES orca.page(id),
	write boolean not null
);

INSERT INTO orca.user_page_permission (user_id, page_id, write) VALUES
	((SELECT id from orca.user where username = 'admin'),
	(SELECT id from orca.page where url = '.*'), true);


CREATE VIEW orca.user_page_permission_view AS
SELECT p.tab, p.url,
	   u.write, u.user_id
FROM (orca.page p JOIN orca.user_page_permission u on (p.id = u.page_id));

CREATE TABLE orca.group (
	id serial primary key,
	name character varying unique not null
);


CREATE TABLE orca.group_page_permission (
	id serial primary key,
	group_id integer REFERENCES orca.group(id),
	page_id integer REFERENCES orca.page(id),
	write boolean not null
);


CREATE VIEW orca.group_page_permission_view AS
SELECT p.tab, p.url,
	   g.write, g.group_id
FROM (orca.page p JOIN orca.group_page_permission g on (p.id = g.page_id));
