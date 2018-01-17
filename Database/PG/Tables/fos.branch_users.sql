--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 30.03.2015
    Purpose   : Связь пользователя системы и филиала

Change list:
05.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.branch_users', 'U') is NOT NULL
--    drop table dbo.branch_users;
drop table if exists fos.branch_users cascade;
/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        branch_id       - Ссылка на филиал
        user_id         - Ссылка на пользователя
        description     - Описание
        comments        - Коменты
        cu              - Последний изменивший
        cd              - Последняя дата изменений
        ct              - Терминал
        cu_id           - Пользователь
*/
create table fos.branch_users
(
    id              bigint          NOT NULL,
    -- fk here
    branch_id       bigint          NOT NULL,
    user_id         bigint          NOT NULL,
    -- attributes
    active_flag     int             NOT NULL default 0,
    -- description and comments    
    description     varchar(500)    NULL,
    comments        varchar(1000)   NULL,
    -- system info
    cu              varchar(256)    NOT NULL default session_user,
    cd              timestamp       NOT NULL default current_timestamp,
    ct              varchar(256)    NOT NULL default inet_client_addr(),
    cu_id           bigint          NULL,
    -- constraints ---------------------------------------------
    constraint branch_users_pk primary key ( id),
    constraint branch_users_uk unique ( branch_id, user_id),
    constraint branch_users_fk_branch foreign key(branch_id) references fos.branches(id),
    constraint branch_users_fk_user foreign key(user_id) references fos.sys_users(id),
    constraint branch_users_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    constraint branch_users_ch_af check( active_flag in ( 0, 1))
)
;

grant select on fos.branch_users to public;
grant select on fos.branch_users to fos_public;

comment on table fos.branch_users is 'Связь пользователя системы и филиала';

comment on column fos.branch_users.id is 'Уникальный идентификатор экземпляра';
comment on column fos.branch_users.branch_id is 'Ссылка на филиал';
comment on column fos.branch_users.user_id is 'Ссылка на пользователя';
comment on column fos.branch_users.description is 'Описание';
comment on column fos.branch_users.comments is 'Коменты';
comment on column fos.branch_users.cu is 'Крайний изменивший';
comment on column fos.branch_users.cd is 'Крайняя дата изменения';
comment on column fos.branch_users.ct is 'Терминал';
comment on column fos.branch_users.cu_id is 'Пользователь';

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