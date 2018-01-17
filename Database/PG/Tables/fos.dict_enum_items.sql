--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 09.03.2017
    Purpose   : Элементы перечислений

Change list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.dict_enum_items', 'U') is NOT NULL
--    drop table dbo.dict_enum_items;
drop table if exists fos.dict_enum_items;
/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        dict_id         - Ссылка на справочник
        branch_id       - Ссылка на филиал
        code            - Код
        name            - Наименование
        active_flag     - Признак активности: 0 - нет, 1 (default) - да
        description     - Описание
        comments        - Коментарии
        cu              - Последний изменивший
        cd              - Последняя дата изменений
        ct              - Терминал
        cu_id           - Ссылка на пользователя
*/
create table fos.dict_enum_items
(
    id              bigint          NOT NULL,
    -- fk here
    dict_enum_id    bigint          NOT NULL,
    branch_id       bigint          NULL,
    -- attributes
    code            varchar(50)     NOT NULL,
    name            varchar(100)    NOT NULL,
    active_flag     int             NOT NULL default 1,
    -- description and comments    
    description     varchar(500)    NULL,
    comments        varchar(1000)   NULL,
    -- system info
    cu              varchar(256)    NOT NULL default session_user,
    cd              timestamp       NOT NULL default current_timestamp,
    ct              varchar(256)    NOT NULL default inet_client_addr(),
    cu_id           bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_enum_items_pk primary key (id),
    constraint dict_enum_items_fk_dict foreign key( dict_enum_id) references fos.dict_enums(id),
    constraint dict_enum_items_fk_branch foreign key( branch_id) references fos.branches(id),
    constraint dict_enum_items_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    constraint dict_enum_items_uk_code unique ( dict_enum_id, code, branch_id),
    constraint dict_enum_items_ch_af
        check( active_flag in ( 0, 1))
)
;

grant select on fos.dict_enum_items to public;
grant select on fos.dict_enum_items to fos_public;

comment on table fos.dict_enum_items is 'Справочник элементы перечислений';

comment on column fos.dict_enum_items.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_enum_items.dict_enum_id is 'Ссылка на перечисление (группу)';
comment on column fos.dict_enum_items.branch_id is 'Ссылка на филиал';
comment on column fos.dict_enum_items.code is 'Код';
comment on column fos.dict_enum_items.name is 'Наименование';
comment on column fos.dict_enum_items.active_flag is 'Признак активности: 0 - нет, 1 (default) да';
comment on column fos.dict_enum_items.description is 'Описание';
comment on column fos.dict_enum_items.comments is 'Коменты';
comment on column fos.dict_enum_items.cu is 'Изменил';
comment on column fos.dict_enum_items.cd is 'Изменили';
comment on column fos.dict_enum_items.ct is 'Терминал';
comment on column fos.dict_enum_items.cu_id is 'Пользователь';

/*  
-- SQL запросы
select
    *
from
    fos.dict_enum_items;


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