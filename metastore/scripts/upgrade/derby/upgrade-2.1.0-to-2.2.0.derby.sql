-- Upgrade MetaStore schema from 2.1.0 to 2.2.0

UPDATE "APP".VERSION SET SCHEMA_VERSION='2.2.0', VERSION_COMMENT='Hive release version 2.2.0' where VER_ID=1;
