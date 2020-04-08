INSERT INTO orca.page (tab, url, loadUrl, crudUrl, parentId, name, title) VALUES
	('data', '/acl', '/tables/acl_view_json', '/tables/access_item', 'list_id', 'Network Data', 'ACL Management'),
	('data', '/server', '/tables/server_view_json', '/tables/server_item', 'type_id', 'Network Data', 'Server Management'),
	('data', '/.*', '', '', '', '', '')
;

INSERT INTO orca.group (name) VALUES ('tchnsg');

INSERT INTO orca.group_page_permission (group_id, page_id, write) VALUES
	((SELECT id from orca.group where name = 'tchnsg'),
	(SELECT id from orca.page where tab = 'data' and url = '/.*' ), true);
