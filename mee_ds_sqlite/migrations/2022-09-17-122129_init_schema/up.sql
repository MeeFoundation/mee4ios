-- Your SQL goes here
CREATE TABLE dscontainer (
	did VARCHAR NOT NULL PRIMARY KEY,
	name VARCHAR NOT NULL,
	version INT NOT NULL,
	version_signature TEXT NOT NULL,
	enc_keys TEXT NOT NULL,
	enc_config TEXT NOT NULL,
	data TEXT
);
