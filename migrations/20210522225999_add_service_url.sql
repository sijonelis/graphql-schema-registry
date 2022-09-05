ALTER TABLE "services" ADD COLUMN url varchar(255) DEFAULT null;

COMMENT ON COLUMN  "services".url is 'Url for a specific service';