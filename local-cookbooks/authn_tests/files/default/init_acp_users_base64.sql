-- database for authn/authz tables
-- CREATE DATABASE acp_users;

CREATE TABLE config (
	config_key varchar(64),
	value varchar(255),
PRIMARY KEY (config_key)
) ENGINE = INNODB;

-- user/passwd table
-- For AES encryption the passwd column must be a BLOB or TINYBLOB:
-- user_passwd BLOB, 
-- Since AES is symmetric encryption, the user's password is the 
-- key to encrypt a known phrase:
-- INSERT INTO acp_users.users 
--   ( user_name, user_password ) 
--   VALUES ( 'user-name', 
--	          AES_ENCRYPT ( 'knownphrase', 'user-entered-password' ) );
 

CREATE TABLE acp_users.users (
  uid VARCHAR(64) NOT NULL,
  idn VARCHAR(8) NOT NULL UNIQUE,
  user_passwd VARCHAR(160) NOT NULL, -- for MD5, SHA1/2
  PRIMARY KEY (uid)
)  ENGINE = INNODB;

-- groups table
CREATE TABLE acp_users.groups (
 uid varchar(64) NOT NULL,
  idn varchar(8) NOT NULL,
  user_group char(20) NOT NULL,
  PRIMARY KEY (uid, idn, user_group)
) ENGINE = INNODB;

-- sessions table

-- stored proc for initial creation, updating of encrypted passwd
CREATE TRIGGER users_insert_sha_passwd 
BEFORE INSERT ON acp_users.users
FOR EACH ROW SET NEW.user_passwd = concat('{SHA}', BASE64_ENCODE(SHA1(NEW.user_passwd)));

CREATE TRIGGER users_update_sha_passwd
BEFORE UPDATE ON acp_users.users
FOR EACH ROW SET NEW.user_passwd = concat('{SHA}', BASE64_ENCODE(SHA1(NEW.user_passwd)));


-- accounts: one that can do maint, one for Apache that's read-only
INSERT INTO acp_users.users (uid, idn, user_passwd) values ('testuser1', '00000001', 'testpasswd1');
INSERT INTO acp_users.groups (uid, idn, user_group) values ('testuser1', '00000001', 'testgroup1');
INSERT INTO acp_users.groups (uid, idn, user_group) values ('testuser1', '00000001', 'commongroup');

INSERT INTO acp_users.users (uid, idn, user_passwd) values ('testuser2', '00000002', 'testpasswd2');
INSERT INTO acp_users.groups (uid, idn, user_group) values ('testuser2', '00000002', 'testgroup2');
INSERT INTO acp_users.groups (uid, idn, user_group) values ('testuser2', '00000002', 'commongroup');

INSERT INTO acp_users.users (uid, idn, user_passwd) values ('testuser3', '00000003', 'testpasswd3');
INSERT INTO acp_users.groups (uid, idn, user_group) values ('testuser3', '00000003', 'testgroup3');
INSERT INTO acp_users.groups (uid, idn, user_group) values ('testuser3', '00000003', 'commongroup');

