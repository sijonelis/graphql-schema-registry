CREATE TABLE IF NOT EXISTS persisted_queries
(
    "key"        varchar(100) NOT NULL,
    query        text         NOT NULL,
    is_active    BOOLEAN          NOT NULL DEFAULT '1',
    updated_time TIMESTAMP    DEFAULT NULL,
    added_time   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("key")
);

CREATE FUNCTION update_updated_time_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    NEW.updated_time = NOW();
    RETURN NEW;
  END;
$$;

CREATE TRIGGER persisted_queries_updated_time_modtime BEFORE UPDATE ON persisted_queries FOR EACH ROW EXECUTE PROCEDURE update_updated_time_column();

CREATE TABLE IF NOT EXISTS services
(
    id           SERIAL NOT NULL,
    name         varchar(255) NOT NULL DEFAULT '',
    is_active    BOOLEAN          NOT NULL DEFAULT '1',
    updated_time TIMESTAMP              DEFAULT NULL,
    added_time   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE TRIGGER services_updated_time_modtime BEFORE UPDATE ON services FOR EACH ROW EXECUTE PROCEDURE update_updated_time_column();

CREATE TABLE IF NOT EXISTS "schema"
(
	  id           SERIAL 	   NOT NULL,
    service_id   int           DEFAULT NULL,
    is_active    BOOLEAN       DEFAULT '1',
    type_defs    text,
    added_time   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_time TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT schema_ibfk_1 FOREIGN KEY (service_id) REFERENCES services (id) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON COLUMN  "schema".type_defs is 'Graphql schema definition for specific service';
COMMENT ON COLUMN  "schema".is_active is 'If schema is deleted, this is set to 0';
COMMENT ON COLUMN  "schema".added_time is 'Time of first registration';
COMMENT ON COLUMN  "schema".updated_time is 'Time of last registration OR deactivation';

CREATE TRIGGER schema_updated_time_modtime BEFORE UPDATE ON "schema" FOR EACH ROW EXECUTE PROCEDURE update_updated_time_column();

CREATE TABLE IF NOT EXISTS container_schema
(
    id         SERIAL NOT NULL,
    service_id int NOT NULL,
    schema_id  int NOT NULL,
    version    varchar(100) NOT NULL DEFAULT '',
    added_time TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE (service_id, version),
    UNIQUE (service_id),
    CONSTRAINT container_schema_ibfk_1 FOREIGN KEY (service_id) REFERENCES services (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT container_schema_ibfk_2 FOREIGN KEY (schema_id) REFERENCES "schema" (id) ON DELETE CASCADE ON UPDATE CASCADE
);