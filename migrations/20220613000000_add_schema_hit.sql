CREATE TABLE IF NOT EXISTS clients (
	 id SERIAL NOT NULL,
	 "name" varchar(50) NOT NULL DEFAULT '',
	 "version" varchar(50) DEFAULT '',
	 calls bigint DEFAULT NULL,
	 updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	 added_time TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	 PRIMARY KEY (id),
	 UNIQUE ("name", "version")
);

CREATE TRIGGER clients_updated_time_modtime BEFORE UPDATE ON clients FOR EACH ROW EXECUTE PROCEDURE update_updated_time_column();

CREATE TABLE IF NOT EXISTS clients_persisted_queries_rel (
   version_id BIGINT NOT NULL,
   pq_key varchar(100) NOT NULL DEFAULT '',
   unique (version_id, pq_key)
);

CREATE TABLE schema_hit (
	client_id BIGINT DEFAULT NULL,
	entity  varchar(150) NOT NULL DEFAULT '',
	property  varchar(150) NOT NULL DEFAULT '',
	"day" date NOT NULL,
	hits bigint DEFAULT NULL,
	updated_time BIGINT NULL DEFAULT NULL,
	UNIQUE (client_id, entity, property, "day")
);
