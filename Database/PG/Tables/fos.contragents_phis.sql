--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 03.06.2016
    Purpose   : Контрагенты физ.лица

Change list:
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.[contragents_phis]', 'U') is NOT NULL
--    drop table dbo.[contragents_phis];
drop table fos.contragents_phis cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        -- ..

        -- Атрибуты
        last_name           - Фамилия
        first_name          - Имя
        patronymic          - Отчество
        name                - ФИО
        lat_name            - ФИО на латинице
        norm_name           - Нормализованное произвольное наименование (в верхнем регистре)
        norm_lat_name       - Нормализованное наименование на латинице (в верхнем регистре)
        short_name          - ФИО кратко
        full_name           - ФИО полностью
        birth_date          - Дата рождения
        birth_place         - Место рождения
        death_date          - Дата смерти

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.contragents_phis
(
    id                  bigint          NOT NULL,
    -- Ссылки
    -- Атрибуты
    last_name           varchar(100)    NOT NULL,
    first_name          varchar(100)    NOT NULL,
    patronymic          varchar(100)    NULL,
    name                varchar(100)    NOT NULL,
    lat_name            varchar(100)    NULL,
    norm_name           varchar(100)    NOT NULL,
    norm_lat_name       varchar(100)    NULL,
    short_name          varchar(100)    NULL,
    full_name           varchar(100)    NULL,
    birth_date          timestamp       NULL,
    birth_place         varchar(100)    NULL,
    death_date          timestamp       NULL,
    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint contragents_phis_pk primary key ( id),
    constraint contragents_phis_fk_contragent foreign key( id) references fos.contragents(id),
    constraint contragents_phis_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
);

grant select on fos.contragents_phis to public;
grant select on fos.contragents_phis to fos_public;

comment on table fos.contragents_phis is 'Контрагенты ф.л.';

comment on column fos.contragents_phis.id is 'Уникальный идентификатор экземпляра';
comment on column fos.contragents_phis.last_name is 'Фвмилия';
comment on column fos.contragents_phis.first_name is 'Имя';
comment on column fos.contragents_phis.patronymic is 'Отчество';
comment on column fos.contragents_phis.name is 'ФИО';
comment on column fos.contragents_phis.lat_name is 'ФИО латиницей';
comment on column fos.contragents_phis.norm_name is 'Нормализованное произвольное наименование (в верхнем регистре)';
comment on column fos.contragents_phis.norm_lat_name is 'Нормализованное наименование на латинице (в верхнем регистре)';
comment on column fos.contragents_phis.short_name is 'ФИО кратко';
comment on column fos.contragents_phis.full_name is 'ФИО полностью';
comment on column fos.contragents_phis.birth_date is 'Дата рождения';
comment on column fos.contragents_phis.birth_place is 'Место рождения';
comment on column fos.contragents_phis.death_date is 'Дата смерти';
comment on column fos.contragents_phis.description is 'Описание';
comment on column fos.contragents_phis.comments is 'Коменты';
comment on column fos.contragents_phis.cu is 'Крайний изменивший';
comment on column fos.contragents_phis.cd is 'Крайняя дата изменений';
comment on column fos.contragents_phis.ct is 'Терминал';
comment on column fos.contragents_phis.cu_id is 'Пользователь';

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
    dbo.sys_settings with (NoLock)

select
    *
from 
    dbo.v_dicts
order by 
    1, 
    4
*/
