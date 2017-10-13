/*
    Developer : Перепечко А.В.
    Created   : 07.10.2017
    Purpose   : Последовательность для объектов учёта
*/
CREATE SEQUENCE fos.seq_objects
  INCREMENT 1
  MINVALUE 1
--  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE fos.seq_objects
  OWNER TO postgres;
GRANT ALL ON SEQUENCE fos.seq_objects TO postgres;
GRANT SELECT ON SEQUENCE fos.seq_objects TO public;
GRANT SELECT ON SEQUENCE fos.seq_objects TO fos_public;
COMMENT ON SEQUENCE fos.seq_objects
  IS 'Последовательность для объектов учёта';
