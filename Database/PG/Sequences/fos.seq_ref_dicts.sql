﻿/*
    Developer : Перепечко А.В.
    Created   : 07.10.2017
    Purpose   : Последовательность для прикладных справочников
*/
CREATE SEQUENCE fos.seq_ref_dicts
  INCREMENT 1
  MINVALUE 1
--  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE fos.seq_ref_dicts
  OWNER TO postgres;
GRANT ALL ON SEQUENCE fos.seq_ref_dicts TO postgres;
GRANT SELECT ON SEQUENCE fos.seq_ref_dicts TO public;
GRANT SELECT ON SEQUENCE fos.seq_ref_dicts TO fos_public;
COMMENT ON SEQUENCE fos.seq_ref_dicts
  IS 'Последовательность для прикладных справочников';