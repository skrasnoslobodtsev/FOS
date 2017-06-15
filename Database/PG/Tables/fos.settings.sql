--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 30.03.2015
    Purpose   : Настройки прикладного уровня

Change list:
04.05.2017 Перепечко А.В. Добиваем недостающие столбцы
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
14.05.2017 Перепечко А.В. Переносим на PG
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.settings', 'U') is NOT NULL
--    drop table dbo.settings;
drop table fos.settings cascade;
/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        branch_id       - Ссылка на филиал
        code            - Код
        name            - Наименование
        value           - Значение
        description     - Описание
        comments        - Коментарии
        change_user     - Последний изменивший
        change_date     - Последняя дата изменений
        change_term     - Терминал
        change_user_id  - Пользователь
*/
create table fos.settings
(
    id              bigint          NOT NULL,
    -- fk here
    branch_id       bigint          NULL,
    -- attributes
    code            varchar(50)     NULL,
    name            varchar(100)    NOT NULL,
    value           varchar(1000)   NOT NULL,
    -- description and comments    
    description     varchar(500)    NULL,
    comments        varchar(1000)   NULL,
    -- system info
    change_user     varchar(256)    NOT NULL default session_user,
    change_date     timestamp       NOT NULL default current_timestamp,
    change_term     varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id  bigint          NULL,
    -- constraints ---------------------------------------------
    constraint settings_pk primary key (id),
    constraint settings_fk_cu_id foreign key ( change_user_id) references fos.sys_users( id),
    constraint settings_fk_branch foreign key (branch_id) references fos.branches(id),
    constraint settings_uk_code unique ( branch_id, code)
)
;

grant select on fos.settings to public;
grant select on fos.settings to fos_public;

comment on table fos.settings is 'Настройки прикладного уровня';

comment on column fos.settings.id is 'Уникальный идентификатор экземпляра';
comment on column fos.settings.branch_id is 'Сслыка на филиал';
comment on column fos.settings.code is 'Код';
comment on column fos.settings.name is 'Наименование';
comment on column fos.settings.value is 'Значение';
comment on column fos.settings.description is 'Описание';
comment on column fos.settings.comments is 'Коменты';
comment on column fos.settings.change_user is 'Крайний изменивший';
comment on column fos.settings.change_date is 'Крайняя дата изменений';
comment on column fos.settings.change_term is 'Терминал';
comment on column fos.settings.change_user_id is 'Пользователь';

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