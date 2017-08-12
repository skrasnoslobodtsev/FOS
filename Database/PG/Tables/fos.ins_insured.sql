--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 12.08.2017
    Purpose   : Объекты учёта, застрахованные

Change list:
12.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.ins_insured', 'U') is NOT NULL
--    drop table dbo.ins_insured;
--go
drop table fos.ins_insured cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра

        -- Ссылки
        ins_conract_id          - Ссылка на договор страхования
        contragent_id           - Ссылка на контрагента

        -- Атрибуты
        primary_flag            - Признак основного застрахованного: 0 (default) - нет, 1 - да

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты
        
        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.ins_insured
(
    id                  bigint          NOT NULL,
    -- Ссылки
    ins_contract_id     bigint          NOT NULL,
    contragent_id       bigint          NOT NULL,

    -- Атрибуты
    primary_flag        int             NOT NULL default 0,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint ins_insured_pk primary key ( id),
    -- Ссылки
    constraint ins_insured_fk_ins_contract foreign key ( ins_contract_id) references fos.ins_contracts( id),
    constraint ins_insured_fk_contragent foreign key ( contragent_id) references fos.contragents( id),
    constraint ins_insured_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint ins_insured_uk unique( ins_contract_id, contragent_id),
    -- Проверки
    constraint ins_insured_ch_pf check( primary_flag in ( 0, 1))
);

grant select on fos.ins_insured to public;
grant select on fos.ins_insured to fos_public;

comment on table fos.ins_insured is 'Объекты учёта, застрахованные';

comment on column fos.ins_insured.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_insured.ins_contract_id is 'Ссылка на договор';
comment on column fos.ins_insured.contragent_id is 'Ссылка на контрагента';
comment on column fos.ins_insured.primary_flag is 'Признак основного застрахованного: 0 (default) - нет, 1 - да';
comment on column fos.ins_insured.description is 'Описание';
comment on column fos.ins_insured.comments is 'Коменты';
comment on column fos.ins_insured.cu is 'Крайний изменивший';
comment on column fos.ins_insured.cd is 'Крайняя дата изменений';
comment on column fos.ins_insured.ct is 'Терминал';
comment on column fos.ins_insured.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.ins_insured
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
