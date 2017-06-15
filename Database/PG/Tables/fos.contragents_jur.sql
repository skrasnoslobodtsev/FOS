--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 10.06.2016
    Purpose   : Контрагенты ю.л.

Change list:
05.05.2017 Перепечко А.В. Добиваем поля
05.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
*/
--if OBJECT_ID( 'dbo.[contragents_jur]', 'U') is NOT NULL
--    drop table dbo.[contragents_jur];
drop table fos.contragents_jur cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        reg_country_id      - Ссылка на страну регистрации

        -- Атрибуты
        name                - Произвольное наименование
        lat_name            - Произвольное наименование на латинице
        norm_name           - Нормализованное произвольное наименование (в верхнем регистре)
        norm_lat_name       - Нормализованное наименование на латинице (в верхнем регистре)
        short_name          - Краткое наименование
        full_name           - Полное наименование
        psrn                - ОГРН (основной государственный регистрационный номер)
        reg_date            - Дата регистрации
        rac                 - КПП (код причины постановки на учёт)
        okato               - ОКАТО (общероссийский классификатор объектов административно-территориального деления)
        oktmo               - ОКТМО (общероссийским классификатором территориальных муниципальных образований)
        founded_date        - Дата основания ю.л.
        close_date          - Дата закрытия ю.л.

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        change_user         - Пользователь
        chnage_date         - Дата последнего изменения
        change_term         - Терминал
        change_user_id      - Ссылка на юзверя
*/
create table fos.contragents_jur
(
    id                  bigint          NOT NULL,
    -- Ссылки
    reg_country_id      bigint          NULL,
    -- Атрибуты
    name                varchar(100)    NOT NULL,
    lat_name            varchar(100)    NULL,
    norm_name           varchar(100)    NOT NULL,
    norm_lat_name       varchar(100)    NULL,
    short_name          varchar(100)    NULL,
    full_name           varchar(100)    NULL,
    psrn                varchar(50)     NULL,
    reg_date            timestamp       NULL,
    rac                 varchar(50)     NULL,
    okato               varchar(50)     NULL,
    oktmo               varchar(50)     NULL,
    founded_date        timestamp       NULL,
    close_date          timestamp       NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    change_user         varchar(256)    NOT NULL default session_user,
    change_date         timestamp       NOT NULL default current_timestamp,
    change_term         varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id      bigint          NULL,
    -- constraints ---------------------------------------------
    constraint contragents_jur_pk primary key ( id),
    constraint contragents_jur_fk_contragent foreign key( id) references fos.contragents( id),
    constraint contragents_jur_fk_cu_id foreign key( change_user_id) references fos.sys_users( id)
--        ,
--    constraint contragents_jur_uk_psrn
--        unique( psrn)
)
;

grant select on fos.contragents_jur to public;
grant select on fos.contragents_jur to fos_public;

comment on table fos.contragents_jur is 'Справочник контрагентов ю.л.';

comment on column fos.contragents_jur.id is 'Уникальный идентификатор экземпляра и ссылка на fos.contragents(id)';
comment on column fos.contragents_jur.reg_country_id is 'Ссылка на страну регистрации';
comment on column fos.contragents_jur.name is 'Произвольное наименование';
comment on column fos.contragents_jur.lat_name is 'Произвольное наименование на латинице';
comment on column fos.contragents_jur.norm_name is 'Нормализованное произвольное наименование (в верхнем регистре)';
comment on column fos.contragents_jur.norm_lat_name is 'Нормализованное наименование на латинице (в верхнем регистре)';
comment on column fos.contragents_jur.short_name is 'Краткое наименование';
comment on column fos.contragents_jur.full_name is 'Полное наименование';
comment on column fos.contragents_jur.psrn is 'ОГРН (основной государственный регистрационный номер)';
comment on column fos.contragents_jur.reg_date is 'Дата регистрации';
comment on column fos.contragents_jur.rac is 'КПП';
comment on column fos.contragents_jur.okato is 'ОКАТО';
comment on column fos.contragents_jur.oktmo is 'ОКТМО';
comment on column fos.contragents_jur.founded_date is 'Дата основания';
comment on column fos.contragents_jur.close_date is 'Дата закрытия';
comment on column fos.contragents_jur.description is 'Описание';
comment on column fos.contragents_jur.comments is 'Коменты';
comment on column fos.contragents_jur.change_user is 'Пользователь';
comment on column fos.contragents_jur.change_date is 'Крайняя дата изменения';
comment on column fos.contragents_jur.change_term is 'Терминал';
comment on column fos.contragents_jur.change_user_id is 'Пользователь';


/*  
-- Проверка
select
    *
from
    fos.contragents_jur
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