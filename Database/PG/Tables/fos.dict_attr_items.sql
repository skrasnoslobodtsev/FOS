--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 25.10.2016
    Purpose   : Справочник атрибутов, в этой сущности описание атрибутов

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.[dict_attr_items]', 'U') is NOT NULL
--    drop table dbo.[dict_attr_items];
--go
drop table if exists fos.dict_attr_items cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        attr_group_id       - Ссылка на группу атрибутов
        data_type_id        - Ссылка на тип данных ( перечисления: string, int, float, datetime, boolean)

        -- Атрибуты
        code                - Код
        name                - Наименование
        active_flag         - Признак активности: 0 - нет, 1 (default) - да
        null_flag           - Признак содержания NULL: 0 - нет, 1 (default) - да
        default_value       - Значение по умолчанию

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.dict_attr_items
(
    id                  bigint          NOT NULL,
    -- Ссылки
    attr_group_id       bigint          NOT NULL,
    data_type_id        bigint          NOT NULL,

    -- Атрибуты
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    active_flag         int             NOT NULL default 1,
    null_flag           int             NOT NULL default 1,
    default_value       varchar(2000)   NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_attr_items_pk primary key ( id),   
    constraint dict_attr_items_fk_attr_group foreign key( attr_group_id) references fos.dict_attr_groups( id),
    constraint dict_attr_items_fk_data_type foreign key( data_type_id) references fos.dict_enum_items( id),
    constraint dict_attr_items_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Проверки
    constraint dict_attr_items_ch_af check( active_flag in ( 0, 1)),
    constraint dict_attr_items_ch_nf check( null_flag in ( 0, 1))
)
;

grant select on fos.dict_attr_items to public;
grant select on fos.dict_attr_items to fos_public;

comment on table fos.dict_attr_items is 'Справочник дополнительных атрибутов сущностей';

comment on column fos.dict_attr_items.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_attr_items.attr_group_id is 'Ссылка на группу доп.атрибутов, справочник fos.dict_attr_groups';
comment on column fos.dict_attr_items.data_type_id is 'Ссылка на тип данных, справочник fos.dict_enum_items';
comment on column fos.dict_attr_items.code is 'Код';
comment on column fos.dict_attr_items.name is 'Наименование';
comment on column fos.dict_attr_items.active_flag is 'Признак активности: 0 - нет, 1 (default) - да';
comment on column fos.dict_attr_items.null_flag is 'Признак пустого значения: 0 - нет, 1 (default) - да';
comment on column fos.dict_attr_items.default_value is 'Значение по умолчанию';
comment on column fos.dict_attr_items.description is 'Описание';
comment on column fos.dict_attr_items.comments is 'Коменты';
comment on column fos.dict_attr_items.cu is 'Крайний изменивший';
comment on column fos.dict_attr_items.cd is 'Крайняя дата изменения';
comment on column fos.dict_attr_items.ct is 'Терминал';
comment on column fos.dict_attr_items.cu_id is 'Пользователь';

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
