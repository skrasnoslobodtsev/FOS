--use [fos_db_dev]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 30.11.2017
    Purpose   : Контрагенты ИП

Change list:
09.12.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'fos.[contragents_ib]', 'U') is NOT NULL
--    drop table fos.[contragents_ib];
drop table if exists fos.contragents_ib cascade;

/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        -- ..

        -- Атрибуты
        psrn                - ОГРН (основной государственный регистрационный номер)
        reg_date            - Дата регистрации
        rac                 - КПП (код причины постановки на учёт)
        okato               - ОКАТО (общероссийский классификатор объектов административно-территориального деления)
        oktmo               - ОКТМО (общероссийским классификатором территориальных муниципальных образований)
        founded_date        - Дата основания ю.л.
        close_date          - Дата закрытия

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.contragents_ib
(
    id                  bigint          NOT NULL,
    -- Ссылки
    -- Атрибуты
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
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint contragents_ib_pk primary key ( id),
    constraint contragents_ib_fk_contragent_phis foreign key( id) references fos.contragents_phis(id),
    constraint contragents_ib_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
);

comment on table fos.contragents_ib is 'Контрагенты: ИП';

comment on column fos.contragents_ib.id is 'УИЭ, ссылка на ф.л.';
comment on column fos.contragents_ib.psrn is 'ОГРН';
comment on column fos.contragents_ib.reg_date is 'Дата регистрации';
comment on column fos.contragents_ib.rac is 'КПП';
comment on column fos.contragents_ib.okato is 'ОКАТО';
comment on column fos.contragents_ib.oktmo is 'ОКТМО';
comment on column fos.contragents_ib.founded_date is 'Дата основания';
comment on column fos.contragents_ib.close_date is 'Дата закрытия';
comment on column fos.contragents_ib.description is 'Описание';
comment on column fos.contragents_ib.comments is 'Коменты';
comment on column fos.contragents_ib.cu is 'Пользователь';
comment on column fos.contragents_ib.cd is 'Крайняя дата изменения';
comment on column fos.contragents_ib.ct is 'Теримнал';
comment on column fos.contragents_ib.cu_id is 'Ссыолка на пользователя';

grant select on fos.contragents_ib to public;
grant select on fos.contragents_ib to fos_public;

/*  
-- Проверка
select
    *
from
    fos.[table_name]
;

-- SQL запросы 
select
    error_code,
    error_message
from 
    fos.sys_errors with (NoLock)
order by 
    error_code desc
;

select
    *
from 
    fos.sys_settings with (NoLock)

select
    *
from 
    fos.v_dicts
order by 
    1, 
    4
*/
