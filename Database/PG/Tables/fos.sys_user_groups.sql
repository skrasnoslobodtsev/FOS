--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 27.03.2017
    Purpose   : Группы пользователя

Change list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
*/
--if OBJECT_ID( 'dbo.sys_user_groups', 'U') is NOT NULL
--    drop table dbo.sys_user_groups;
drop table fos.sys_user_groups cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        sys_group_id        - Ссылка на группу
        sys_user_id         - Ссылка на юзверя

        -- Атрибуты
        username            - Пользователь (для совместимости с сервером приложений)

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        change_user         - Пользователь
        chnage_date         - Дата последнего изменения
        change_term         - Терминал
        change_user_id      - Ссылка на юзверя
*/
create table fos.sys_user_groups
(
    id                  bigint          NOT NULL,
    -- Ссылки
    sys_group_id        bigint          NOT NULL,
    sys_user_id         bigint          NOT NULL,
    -- Атрибуты
    username            varchar(100)    NOT NULL,

    -- Не обязательные, но тоже есть у всех
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- Системные
    change_user         varchar(256)    NOT NULL default session_user,
    change_date         timestamp       NOT NULL default current_timestamp,
    change_term         varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id      bigint          NULL,
    -- Ограничения
    constraint sys_user_groups_pk
        primary key ( id),
    constraint sys_user_groups_fk_sys_group
        foreign key( sys_group_id) references fos.sys_groups( id),
    constraint sys_user_groups_fk_sys_user
        foreign key( sys_user_id) references fos.sys_users( id),
    constraint sys_user_groups_uk
        unique( sys_user_id, sys_group_id),
    constraint sys_user_groups_fk_username
        foreign key( username) references fos.sys_users( username),
    constraint sys_user_groups
        foreign key( change_user_id) references fos.sys_users( id)
)
;


create index sys_user_groups_idx_users on fos.sys_user_groups( username);
create index sys_user_groups_idx_groups on fos.sys_user_groups( sys_group_id);

grant select on fos.sys_user_groups to public;
grant select on fos.sys_user_groups to fos_public;

comment on table fos.sys_user_groups is 'Группы пользователей';

comment on column fos.sys_user_groups.id is 'Уникальный идентификатор экземпляра';
comment on column fos.sys_user_groups.sys_group_id is 'Ссылка на группу';
comment on column fos.sys_user_groups.sys_user_id is 'Ссылка на пользователя';
comment on column fos.sys_user_groups.username is 'Пользователь';
comment on column fos.sys_user_groups.description is 'Описание';
comment on column fos.sys_user_groups.comments is 'Коменты';
comment on column fos.sys_user_groups.change_user is 'Изменил';
comment on column fos.sys_user_groups.change_date is 'Изменили';
comment on column fos.sys_user_groups.change_term is 'Терминал';
comment on column fos.sys_user_groups.change_user_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.sys_user_groups
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
    dbo.sys_settings with (NoLock)

select
    *
from 
    dbo.v_dicts
order by 
    1, 
    4
*/