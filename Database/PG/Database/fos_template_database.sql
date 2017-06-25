-- Database: fos_db_template

-- DROP DATABASE fos_db_template;

CREATE DATABASE fos_db_template
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = fos
       LC_COLLATE = 'Russian_Russia.1251'
       LC_CTYPE = 'Russian_Russia.1251'
       CONNECTION LIMIT = -1;

COMMENT ON DATABASE fos_db_template
  IS 'Чистая БД для копирования';
