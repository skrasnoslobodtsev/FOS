--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 25.10.2016
    Purpose   : Справочник атрибутов, в этой сущности группировки

Change list:
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.[dict_attr_groups]', 'U') is NOT NULL
--  drop table dbo.[dict_attr_groups];
--go
drop table fos.dict_attr_groups cascade;
/*
  Атрибуты:
    id                  - Уникальный идентификатор экземпляра
    -- Ссылки
    branch_id           - Ссылка на филиал, если NULL - то для всех
    type_id             - Ссылка на тип объекта, справочник fos.dict_enums
    kind_id             - Ссылка на вид в объекте, справочник fos.duct_enum_items

    -- Атрибуты
    code                - Код
    name                - Наименование
    active_flag         - Признак активности: 0 - нет, 1 (default) - да

    -- Не обязательные, но тоже есть у всех
    description         - Описание
    comments            - Коменты
    -- Системные
    cu                  - Пользователь
    cd                  - Дата последнего изменения
    ct                  - Терминал
    cu_id               - Ссылка на юзверя
*/
create table fos.dict_attr_groups
(
    id                  bigint          NOT NULL,
    -- Ссылки
    branch_id           bigint          NULL,
    type_id             bigint          NOT NULL,
    kind_id             bigint          NOT NULL,

    -- Атрибуты
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    active_flag         int             NOT NULL default 1,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu         varchar(256)    NOT NULL default session_user,
    cd         timestamp       NOT NULL default current_timestamp,
    ct         varchar(256)    NOT NULL default inet_client_addr(),
    cu_id      bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_attr_groups_pk primary key( id),
    constraint dict_attr_groups_fk_branch foreign key( branch_id) references fos.branches( id),
    constraint dict_attr_groups_fk_types foreign key( type_id) references fos.dict_enums( id),
    constraint dict_attr_groups_fk_kinds foreign key( kind_id) references fos.dict_enum_items( id),
    constraint dict_attr_groups_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint dict_attr_groups_uk unique( branch_id, type_id, kind_id, code),
    -- Проверки
    constraint dict_attr_groups_ch_af check( active_flag in ( 0, 1))
)
;

grant select on fos.dict_attr_groups to public;
grant select on fos.dict_attr_groups to fos_public;

comment on table fos.dict_attr_groups is 'Справочник дополнительных атрибутов сущностей, группы';

comment on column fos.dict_attr_groups.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_attr_groups.branch_id is 'Ссылка на филиал';
comment on column fos.dict_attr_groups.type_id is 'Ссылка на тип объекта, справочник fos.dict_enums';
comment on column fos.dict_attr_groups.kind_id is 'Ссылка на вид вид в объекте, справочник fos.dict_enum_items';
comment on column fos.dict_attr_groups.code is 'Код';
comment on column fos.dict_attr_groups.name is 'Наименование';
comment on column fos.dict_attr_groups.active_flag is 'Признак активности: 0 - нет, 1 (default) - да';
comment on column fos.dict_attr_groups.description is 'Описание';
comment on column fos.dict_attr_groups.comments is 'Коменты';
comment on column fos.dict_attr_groups.cu is 'Крайний изменивший';
comment on column fos.dict_attr_groups.cd is 'Крайняя дата изменений';
comment on column fos.dict_attr_groups.ct is 'Терминал';
comment on column fos.dict_attr_groups.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.[table_name]
;

-- SQL запросы 
select
    error_code,
    error_message
from 
    dbo.sys_errors with (NoLock)
order by 
    error_code desc
;

select
  *
from 
    dbo.SysSettings with (NoLock)

select
  *
from dbo.vDictionaries
order by 1, 4
*/
