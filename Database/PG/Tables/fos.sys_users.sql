--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 30.03.2015
    Purpose   : Пользователи системы

Change list:
17.04.2017 Перепечко А.В. Переносим на pg
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.sys_users', 'U') is NOT NULL
--    drop table dbo.sys_users;

drop table fos.sys_users cascade;

/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        code            - Для обратной совместимости - <-- здесь username
        name            - Для обратной совместимости - <-- здесь ФИО юзверя
        username        - login/пользователь
        password        - Пароль
        operator        - ФИО оператора
        active_flag     - Признак активности, 0 - не активен, 1 (default) - активен
        description     - Описание
        comments        - Коментарии
        change_user     - Последний изменивший
        change_date     - Последняя дата изменений
        change_term     - Терминал
        change_user_id  - Ссылка на пользователя
*/
create table fos.sys_users
(
    id              bigint          NOT NULL,
    -- Ссылки
    -- ..
    -- Атрибуты
    code            varchar(100)    NULL,
    name            varchar(100)    NULL,
    username        varchar(100)    NOT NULL,
    password        varchar(100)    NOT NULL,
    operator        varchar(100)    NULL,
    active_flag     int             NOT NULL default 1,
    -- description and comments    
    description     varchar(500)    NULL,
    comments        varchar(1000)   NULL,
    -- system info
    change_user     varchar(256)    NOT NULL default session_user,
    change_date     timestamp       NOT NULL default current_timestamp,
    change_term     varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id  bigint          NULL,
    -- constraints ---------------------------------------------
    constraint sys_users_pk primary key (id),
    constraint sys_users_uk_user unique (username),
    constraint sys_users_chk_af check( active_flag in (0, 1))
)
;

create index sys_users_idx on fos.sys_users( username);

alter table fos.sys_users add constraint sys_users_fk_cu_id foreign key( change_user_id) references fos.sys_users( id);

grant select on fos.sys_users to public;
grant select on fos.sys_users to fos_public;

comment on table fos.sys_users is 'Пользователи системы';

comment on column fos.sys_users.id is 'Уникальный идентификатор экземпляра';
comment on column fos.sys_users.code is 'Для обратной совместимости - <-- здесь username';
comment on column fos.sys_users.name is 'Для обратной совместимости - <-- здесь ФИО юзверя';
comment on column fos.sys_users.username is 'login/пользователь';
comment on column fos.sys_users.password is 'Пароль';
comment on column fos.sys_users.operator is 'ФИО оператора';
comment on column fos.sys_users.active_flag is 'Признак активности, 0 - не активен, 1 (default) - активен';
comment on column fos.sys_users.description is 'Описание';
comment on column fos.sys_users.comments is 'Коменты';
comment on column fos.sys_users.cu is 'Изменил';
comment on column fos.sys_users.cd is 'Изменили';
comment on column fos.sys_users.ct is 'Терминал';
comment on column fos.sys_users.cu_id is 'Пользователь';

/*  
-- SQL запросы
select
    *
from
    fos.sys_users;


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