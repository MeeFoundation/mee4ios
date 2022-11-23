-- SQLite
INSERT INTO dscontainer (did, name, version, version_signature, enc_keys, enc_config, data)
VALUES ('self', 'Self', 1, 'version_signature', 'keys', 'conf', 'empty_data');

INSERT INTO dscontainer (did, name, version, version_signature, enc_keys, enc_config, data)
VALUES ('did:nytimes.com', 'New York Times', 1, '...', 'keys', 'conf', '{sub: "mee:test_subject"}');