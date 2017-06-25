--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 27.03.2017
    Purpose   : Группы

Change list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.sys_groups', 'U') is NOT NULL
--    drop table dbo.sys_groups;
drop table fos.sys_groups cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        -- ..

        -- Атрибуты
        code                - Код группы
        name                - Наименование группы

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.sys_groups
(
    id                  bigint          NOT NULL,
    -- Атрибуты
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NULL,

    -- Не обязательные, но тоже есть у всех
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- Системные
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- Ограничения
    constraint sys_groups_pk
        primary key( id),
    constraint sys_groups_uk
        unique( code),
    constraint sys_groups_fk_cu_id
        foreign key( cu_id) references fos.sys_users( id)
)
;

create index sys_groups_idx on fos.sys_groups( code);

grant select on fos.sys_groups to public;
grant select on fos.sys_groups to fos_public;

comment on table fos.sys_groups is 'Пользовательские группы';

comment on column fos.sys_groups.id is 'Уникальный идентификатор экземпляра';
comment on column fos.sys_groups.code is 'Код';
comment on column fos.sys_groups.name is 'Наименование';
comment on column fos.sys_groups.description is 'Описание';
comment on column fos.sys_groups.comments is 'Коменты';
comment on column fos.sys_groups.cu is 'Изменил';
comment on column fos.sys_groups.cd is 'Изменили';
comment on column fos.sys_groups.ct is 'Терминал';
comment on column fos.sys_groups.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.sys_groups;

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
    dbo.sys_settings with (NoLock)

select
    *
from 
    dbo.v_dicts
order by 
    1, 
    4
*/
