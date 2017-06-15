--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 30.03.2015
    Purpose   : Настройки системы (не редактируются из UI)

Change list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.sys_settings', 'U') is NOT NULL
--    drop table dbo.sys_settings;
drop table fos.sys_settings cascade;


/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        code            - Код
        name            - Наименование
        value           - Значение
        description     - Описание
        comments        - Коментарии
        change_user     - Последний изменивший
        change_date     - Последняя дата изменений
        change_term     - Терминал
        change_user_id  - Ссылка на пользователя
*/
create table fos.sys_settings
(
    id              bigint         NOT NULL,
    -- attributes
    code            varchar(50)   NOT NULL,
    name            varchar(100)  NOT NULL,
    value           varchar(1000) NULL,
    -- description and comments    
    description     varchar(1000) NULL,
    comments        varchar(2000) NULL,
    -- system info
    change_user     varchar(256)   NOT NULL default session_user,
    change_date     timestamp      NOT NULL default current_timestamp,
    change_term     varchar(256)   NOT NULL default inet_client_addr(),
    change_user_id  bigint         NULL,
    -- constraints ---------------------------------------------
    constraint sys_settings_pk primary key(id),
    constraint sys_settings_uk_code unique ( code),
    constraint sys_settings_fk_cu_id foreign key( change_user_id) references fos.sys_users( id)
)
;

grant select on fos.sys_settings to public;
grant select on fos.sys_settings to fos_public;

comment on table fos.sys_settings is 'Системные настройки';

comment on column fos.sys_settings.id is 'Уникальный идентификатор экземпляра';
comment on column fos.sys_settings.code is 'Код';
comment on column fos.sys_settings.name is 'Наименование';
comment on column fos.sys_settings.value is 'Значение';
comment on column fos.sys_settings.description is 'Описание';
comment on column fos.sys_settings.comments is 'Коментарии';
comment on column fos.sys_settings.change_user is 'Изменил';
comment on column fos.sys_settings.change_date is 'Изменили';
comment on column fos.sys_settings.change_term is 'Терминал';
comment on column fos.sys_settings.change_user_id is 'Пользователь';

/*  
-- SQL запросы
select
    *
from
    fos.sys_settings;


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
