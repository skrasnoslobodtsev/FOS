--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 24.03.2015
    Purpose   : Значения элемента простого справочника

Change list:
05.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.dict_enum_item_values', 'U') is NOT NULL
--    drop table dbo.dict_enum_item_values;
drop table fos.dict_enum_item_values cascade;
/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        dict_item_id    - Ссылка на элемент справочника
        branch_id       - Ссылка на филиал
        code            - Код
        name            - Наименование
        value           - Значение
        description     - Описание
        comments        - Коментарии
        change_user     - Последний изменивший
        change_date     - Последняя дата изменений
        chnage_term     - Терминал
        change_user_id  - Ссылка на пользователя
*/
create table fos.dict_enum_item_values
(
    id                  bigint          NOT NULL,
    -- fk here
    dict_enum_item_id   bigint          NOT NULL,
    branch_id           bigint          NULL,
    -- attributes
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    value               varchar(100)    NULL,
    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    change_user         varchar(256)    NOT NULL default session_user,
    change_date         timestamp       NOT NULL default current_timestamp,
    change_term         varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id      bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_enum_item_values_pk primary key (id),
    constraint dict_enum_item_values_fk_dict_item foreign key (dict_enum_item_id) references fos.dict_enum_items(id),
    constraint dict_enum_item_values_fk_branch foreign key (branch_id) references fos.branches( id),
    constraint dict_enum_item_values_fk_cu_id foreign key( change_user_id) references fos.sys_users( id),
    constraint dict_enum_item_values_uk_code unique ( dict_enum_item_id, code, branch_id)
)
;

grant select on fos.dict_enum_item_values to public;
grant select on fos.dict_enum_item_values to fos_public;

comment on table fos.dict_enum_item_values is 'Значения элементов простого справочника перечислений';

comment on column fos.dict_enum_item_values.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_enum_item_values.dict_enum_item_id is 'Ссылка на элемент перечисления';
comment on column fos.dict_enum_item_values.branch_id is 'Ссылка на филилал';
comment on column fos.dict_enum_item_values.code is 'Код';
comment on column fos.dict_enum_item_values.name is 'Наименование';
comment on column fos.dict_enum_item_values.value is 'Значение';
comment on column fos.dict_enum_item_values.description is 'Описание';
comment on column fos.dict_enum_item_values.comments is 'Коменты';
comment on column fos.dict_enum_item_values.change_user is 'Крайний изменивший';
comment on column fos.dict_enum_item_values.change_date is 'Крайняя дата изменения';
comment on column fos.dict_enum_item_values.change_term is 'Терминал';
comment on column fos.dict_enum_item_values.change_user_id is 'Пользователь';

/*  
-- SQL запросы
select
    *
from
    <table_name>;


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