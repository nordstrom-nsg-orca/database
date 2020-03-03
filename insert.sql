INSERT INTO orca.user (username, password) VALUES (
  'admin',
  md5(:admin_password)
);

DO $$
DECLARE ret_id INT;
BEGIN

---- ---- ---- ----- ---- ----
-- ACLS
---- ---- ---- ----- ---- ----
INSERT INTO orca.access_list (name) VALUES ('REMOTE-MANAGEMENT-STATIONS') RETURNING id INTO ret_id;
INSERT INTO orca.access_item (list_id, subnet, description) VALUES
  (ret_id, '10.21.66.86/32', 'NSGTools PROD (a0319p11202'),
  (ret_id, '10.16.23.48/32', 'Infoblox Discovery Appliance (ddidscv1.0319.datacenter.nordstrom.net)'),
  (ret_id, '10.16.23.76/32', 'Jump server (y0319p11015)'),
  (ret_id, '10.16.23.85/32', 'Jump server (y0319p11016'),
  (ret_id, '10.16.23.225/32', 'SW Core (a0319p11796)'),
  (ret_id, '10.16.23.227/32', 'SW APE (a0319p11798)'),
  (ret_id, '10.16.23.229/32', 'SW APE (a0319p11799)'),
  (ret_id, '10.16.23.230/32', 'SW APE (a0319p11800)'),
  (ret_id, '10.16.23.231/32', 'SW APE (a0319p11801)'),
  (ret_id, '10.16.23.232/32', 'SW APE (a0319p11802)'),
  (ret_id, '10.16.150.129/32', 'Live NX (a0319p1254)'),
  (ret_id, '10.17.100.2/32', 'cr319-4a'),
  (ret_id, '10.17.100.3/32', 'cr319-4z'),
  (ret_id, '10.21.66.104/32', 'AWX1 (y0319p11945)'),
  (ret_id, '10.21.66.105/32', 'AWX2 (y0319p11946)'),
  (ret_id, '10.21.66.114/32', 'AWX3 (y0319p11947)'),
  (ret_id, '10.225.50.32/32', 'cr990-4a'),
  (ret_id, '10.225.50.33/32', 'cr990-4z'),
  (ret_id, '10.228.33.224/32', 'CentOS Jump Server (y0990p10150)'),
  (ret_id, '10.228.33.251/32', 'CentOS Jump Server (y0990p10149)'),
  (ret_id, '172.23.40.0/22', 'NSG AWS VPC'),
  (ret_id, '172.23.44.0/22', 'NSG AWS VPC'),
  (ret_id, '10.21.70.0/24', '319 - v154_PROD_NSG_MGMT_10.21.70.0_24'),
  (ret_id, '10.228.52.0/24', '990 - v522_PROD_NSG_MGMT_10.228.52.0_24');

INSERT INTO orca.access_list (name) VALUES ('SNMP-ACCESS-ONLY') RETURNING id INTO ret_id;
INSERT INTO orca.access_item (list_id, subnet, description) VALUES
  (ret_id, '10.17.72.14/32', ''),
  (ret_id, '10.17.72.16/32', ''),
  (ret_id, '10.17.72.17/32', ''),
  (ret_id, '10.17.72.18/32', ''),
  (ret_id, '10.17.72.19/32', ''),
  (ret_id, '10.17.72.20/32', ''),
  (ret_id, '10.17.72.21/32', ''),
  (ret_id, '10.17.72.22/32', ''),
  (ret_id, '10.17.72.23/32', ''),
  (ret_id, '10.17.72.24/32', ''),
  (ret_id, '10.17.72.25/32', ''),
  (ret_id, '10.228.33.162/32', ''),
  (ret_id, '10.228.33.230/32', ''),
  (ret_id, '10.228.33.231/32', ''),
  (ret_id, '10.17.72.15/32', '');

---- ---- ---- ----- ---- ----
-- SERVERS
---- ---- ---- ----- ---- ----
INSERT INTO orca.server_type (name) VALUES('NTP') RETURNING id INTO ret_id;
INSERT INTO orca.server_item (type_id, ip, tag) VALUES
  (ret_id, '10.5.1.10', 'PRIMARY'),
  (ret_id, '10.16.101.16', 'BACKUP');

INSERT INTO orca.server_type (name) VALUES('Tacacs') RETURNING id INTO ret_id;
INSERT INTO orca.server_item (type_id, ip) VALUES
  (ret_id, '10.16.23.39'),
  (ret_id, '10.228.32.32');

INSERT INTO orca.server_type (name) VALUES('Syslog') RETURNING id INTO ret_id;
INSERT INTO orca.server_item (type_id, ip) VALUES
  (ret_id, '10.16.150.104');

INSERT INTO orca.server_type (name) VALUES('SNMP Trap') RETURNING id INTO ret_id;
INSERT INTO orca.server_item (type_id, ip) VALUES
  (ret_id, '10.16.150.104');

END $$;
