--use [template_db]
--go
/*
    Developer : Перепечко А.В.
    Created   : 18.08.2017
    Purpose   : Перечисления, справочник видов адреса

Change list:
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
drop view if exists fos.v_dict_enum_address_kinds cascade;

create or replace view fos.v_dict_enum_address_kinds
as
with recursive cte as
(
    select
        id,
        root_id,
        branch_id,
        1 as level,
        code,
        name,
        system_flag,
        delete_flag
    from
        fos.dict_enums
    where
        root_id = id
    and code = 'dict_address_kinds'
    union all
    select
        i.id,
        i.root_id,
        i.branch_id,
        c.level + 1 as level,
        i.code,
        i.name,
        i.system_flag,
        i.delete_flag
    from
        fos.dict_enums i
        inner join
            cte c
            on
                c.id = i.prior_version_id
)
select
    dei.id,
    dei.branch_id,
    dei.code,
    dei.name,
    dei.description,
    dei.comments,
    dei.dict_enum_id,
    de.branch_id as dict_enum_branch_id,
    de.code as dict_enum_code,
    de.name as dict_enum_name,
    de.root_id as dict_enum_root_id
from
    cte de
    left outer join
        fos.dict_enum_items dei
        on
            dei.dict_enum_id = de.id
;

grant select on fos.v_dict_enum_address_kinds to public;
grant select on fos.v_dict_enum_address_kinds to fos_public;

comment on view fos.v_dict_enum_address_kinds is 'Перечисления, справочник видов адреса';

comment on column fos.v_dict_enum_address_kinds.id is 'Уникальный идентификатор экземпляра';
comment on column fos.v_dict_enum_address_kinds.branch_id is 'Ссылка на филиал';
comment on column fos.v_dict_enum_address_kinds.code is 'Код';
comment on column fos.v_dict_enum_address_kinds.name is 'Наименование';
comment on column fos.v_dict_enum_address_kinds.description is 'Описание';
comment on column fos.v_dict_enum_address_kinds.comments is 'Коменты';
comment on column fos.v_dict_enum_address_kinds.dict_enum_id is 'Уникальный идентификатор перечисления';
comment on column fos.v_dict_enum_address_kinds.dict_enum_branch_id is 'Ссылка на филиал перечисления';
comment on column fos.v_dict_enum_address_kinds.dict_enum_code is 'Код перечисления';
comment on column fos.v_dict_enum_address_kinds.dict_enum_name is 'Наименование перечисления';

/* Test samples

select
    *
from
    fos.v_dict_enum_address_kinds
;  
  
-- SQL запросы
select
  ErrorCode,
  ErrorMessage
from dbo.SysErrors with (NoLock)
order by ErrorCode desc

select
  *
from dbo.SysSettings with (NoLock)

select
  *
from dbo.vDictionaries
order by 1, 4
*/
