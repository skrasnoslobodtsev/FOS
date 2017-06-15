--use [template_db]
--go
/*
    Developer : Перепечко А.В.
    Created   : 07.04.2016
    Purpose   : Таблица с кодами и сообщениями ошибок

Change list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.sys_errors', 'U') is NOT NULL
--    drop table dbo.sys_errors;

drop table fos.sys_errors cascade;

/*
    Атрибуты:
        id             - Уникальный идентификатор экземпляра
        code           - <== Для обратной совместимости, Код ошибки (строка)
        name           - <== Для обратной совместимости, Текст ошибки
        error_code     - Код ошибки. ВНИМАНИЕ!!! В отличии от остальных обьектов, код ошибки цифровой!
        error_message  - Текст
        fmt_message    - Форматированное сообщение
        -- Есть у всех
        description     - Описание
        comments        - Коментарии
        --
        chnage_user    - Последний изменивший
        change_date    - Последнее изменение
        change_term    - Терминал
        change_user_id - Ссылка на пользователя системы
*/
create table fos.sys_errors
(
    id                  bigint          NOT NULL,
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NULL,
    error_code          int             NOT NULL,
    error_message       varchar(2000)   NULL,
    fmt_error_message   varchar(2000)   NULL,
    -- системные
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    change_user         varchar(256)    NOT NULL default session_user,
    change_date         timestamp       NOT NULL default current_timestamp,
    change_term         varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id      bigint          NULL,
    -- Ограничения
    constraint sys_errors_pk
        primary key ( id),
    constraint sys_errors_uk
        unique ( error_code),
    constraint sys_errors_fk_cu_id
        foreign key( change_user_id) references fos.sys_users( id)
);
-- Создаём уникальный индекс на поле error_code
create index sys_errors_idx on fos.sys_errors( error_code desc);

grant select on fos.sys_errors to public;

comment on table fos.sys_errors is 'Ошибки системы';

comment on column fos.sys_errors.id is 'Уникальный идентификатор экземпляра';
comment on column fos.sys_errors.code is '<== Для обратной совместимости, код ошибки';
comment on column fos.sys_errors.name is '<== Для обратной совместимости, сообщение';
comment on column fos.sys_errors.error_code is 'Код';
comment on column fos.sys_errors.error_message is 'Сообщение';
comment on column fos.sys_errors.fmt_error_message is 'Форматированное сообщение';
comment on column fos.sys_errors.description is 'Описание';
comment on column fos.sys_errors.comments is 'Коменты';
comment on column fos.sys_errors.change_user is 'Изменил';
comment on column fos.sys_errors.change_date is 'Изменили';
comment on column fos.sys_errors.change_term is 'Терминал';
comment on column fos.sys_errors.change_user_id is 'Ссылка на юзверя';

/*  
-- SQL запросы 
select
    error_code,
    error_message,
    code,
    name
from 
    dbo.sys_errors with (NoLock)
order by 
    error_code desc
;

select
  *
from dbo.SysSettings with (NoLock)

select
  *
from dbo.vDictionaries
order by 1, 4
*/