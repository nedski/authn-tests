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
  uid CHAR(64) NOT NULL,
  user_passwd CHAR(160) NOT NULL, -- for MD5, SHA1/2
  PRIMARY KEY (uid)
)  ENGINE = INNODB;

-- groups table
CREATE TABLE acp_users.groups (
  uid char(64) NOT NULL,
  user_group char(20) NOT NULL,
  PRIMARY KEY (uid, user_group)
) ENGINE = INNODB;

-- link to IDNs
CREATE TABLE acp_users.users_idns (
	idn varchar(8) NOT NULL,
	uid int NOT NULL,
	PRIMARY KEY (uid, idn)
) ENGINE = INNODB;

-- sessions table

-- stored proc for initial creation, updating of encrypted passwd
CREATE TRIGGER users_insert_sha_passwd 
BEFORE INSERT ON acp_users.users
FOR EACH ROW SET NEW.user_passwd = SHA1(NEW.user_passwd);

CREATE TRIGGER users_update_sha_passwd
BEFORE UPDATE ON acp_users.users
FOR EACH ROW SET NEW.user_passwd = SHA1(NEW.user_passwd);


-- accounts: one that can do maint, one for Apache that's read-only

