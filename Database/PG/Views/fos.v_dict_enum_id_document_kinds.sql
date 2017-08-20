--use [template_db]
--go
/*
    Developer : Перепечко А.В.
    Created   : 09.11.2016
    Purpose   : Перечисления, справочник видов УД

Change list:
13.03.2017 Перепечко А.В. Переносим dbo.dicts на dbo.dict_enums
18.08.2017 Перепечко А.В. Добавляем enum к перечислениям
18.08.2017 Перепечко А.В. Переносим на PG
*/
/*
    Атрибуты:
        id                          - Уникальный идентификатор экземпляра
        branch_id                   - Ссылка на филиал
        code                        - Код
        name                        - Наименование
        description                 - Описание
        comments                    - Коменты
        dict_enum_id                - Уникальный идентификатор перечисления
        dict_enum_branch_id         - Ссылка на филиал
        dict_enum_code              - Код
        dict_enum_name              - Наименование
*/
create or replace view fos.v_dict_enum_id_document_kinds
as
select
    dei.id,
    dei.branch_id,
    dei.code,
    dei.name,
    dei.description,
    dei.comments,
    de.id as dict_enum_id,
    de.branch_id as dict_enum_branch_id,
    de.code as dict_enum_code,
    de.name as dict_enum_name
from
    fos.dict_enum_items dei
    inner join
        fos.dict_enums de
        on
            de.code = 'dict_id_document_kinds'
        and de.id = dei.dict_enum_id
;        

grant select on fos.v_dict_enum_id_document_kinds to public;
grant select on fos.v_dict_enum_id_document_kinds to fos_public;

comment on view fos.v_dict_enum_id_document_kinds is 'Перечисления, справочник видов УД';

comment on column fos.v_dict_enum_id_document_kinds.id is 'Уникальный идентификатор экземпляра';
comment on column fos.v_dict_enum_id_document_kinds.branch_id is 'Ссылка на филиал';
comment on column fos.v_dict_enum_id_document_kinds.code is 'Код';
comment on column fos.v_dict_enum_id_document_kinds.name is 'Наименование';
comment on column fos.v_dict_enum_id_document_kinds.description is 'Описание';
comment on column fos.v_dict_enum_id_document_kinds.comments is 'Коменты';
comment on column fos.v_dict_enum_id_document_kinds.dict_enum_id is 'Уникальный идентификатор перечисления';
comment on column fos.v_dict_enum_id_document_kinds.dict_enum_branch_id is 'Ссылка на филиал перечисления';
comment on column fos.v_dict_enum_id_document_kinds.dict_enum_code is 'Код перечисления';
comment on column fos.v_dict_enum_id_document_kinds.dict_enum_name is 'Наименование перечисления';

/* Test samples

select
    *
from
    dbo.v_dict_enum_id_document_kinds
;  

-- SQL запросы
select
    ErrorCode,
    ErrorMessage
from 
    dbo.SysErrors with (NoLock)
order by 
    ErrorCode desc

select
    *
from 
    dbo.sys_settings with (NoLock)

select
    *
from 
    dbo.vDictionaries
order by 
    1, 
    4
*/
