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
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.settings', 'U') is NOT NULL
--    drop table dbo.settings;
drop table if exists fos.settings cascade;
/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        branch_id       - Ссылка на филиал
        code            - Код
        name            - Наименование
        value           - Значение
        description     - Описание
        comments        - Коментарии
        cu              - Последний изменивший
        cd              - Последняя дата изменений
        ct              - Терминал
        cu_id           - Пользователь
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
    cu              varchar(256)    NOT NULL default session_user,
    cd              timestamp       NOT NULL default current_timestamp,
    ct              varchar(256)    NOT NULL default inet_client_addr(),
    cu_id           bigint          NULL,
    -- constraints ---------------------------------------------
    constraint settings_pk primary key (id),
    constraint settings_fk_cu_id foreign key ( cu_id) references fos.sys_users( id),
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
comment on column fos.settings.cu is 'Крайний изменивший';
comment on column fos.settings.cd is 'Крайняя дата изменений';
comment on column fos.settings.ct is 'Терминал';
comment on column fos.settings.cu_id is 'Пользователь';

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