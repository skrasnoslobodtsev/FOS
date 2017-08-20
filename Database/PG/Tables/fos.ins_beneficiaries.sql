--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 05.08.2016
    Purpose   : Объекты учёта, выгодоприобретатели

Change list:
12.08.2017 Перепечко А.В. Добиваем атрибуты
16.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.ins_beneficiaries', 'U') is NOT NULL
--    drop table dbo.ins_beneficiaries;
drop table fos.ins_beneficiaries cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_contract_id         - Ссылка на контракт
        contragent_id           - Ссылка на контрагента
        ins_contract_riks_id    - Ссылка на риск

        -- Атрибуты
        percent                 - Процент

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты
        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.ins_beneficiaries
(
    id                      bigint          NOT NULL,
    -- Ссылки
    ins_contract_id         bigint          NOT NULL,
    contragent_id           bigint          NOT NULL,
    ins_contract_risk_id    bigint          NULL,
    -- Атрибуты
    part_percent            real            NOT NULL default 0.0,

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------
    constraint ins_beneficiaries_pk primary key ( id),
    -- Ссылки
    constraint ins_beneficiaries_fk_ins_contract foreign key( ins_contract_id) references fos.ins_contracts( id),
    constraint ins_beneficiaries_fk_contragent foreign key( contragent_id) references fos.contragents( id),
    constraint ins_beneficiaries_fk_ins_contract_risk foreign key( ins_contract_risk_id) references fos.ins_contract_risks( id),
    constraint ins_beneficiaries_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Проверки
    constraint ins_beneficiaries_ch_pp check( part_percent > 0.0)
);

grant select on fos.ins_beneficiaries to public;
grant select on fos.ins_beneficiaries to fos_public;

comment on table fos.ins_beneficiaries is 'Объекты учёта, выгодоприобретатели';

comment on column fos.ins_beneficiaries.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_beneficiaries.ins_contract_id is 'Ссылка на договор страхования';
comment on column fos.ins_beneficiaries.contragent_id is 'Ссылка на контрагента';
comment on column fos.ins_beneficiaries.ins_contract_risk_id is 'Ссылка на риск договора страхования';
comment on column fos.ins_beneficiaries.part_percent is 'Процент';
comment on column fos.ins_beneficiaries.description is 'Описание';
comment on column fos.ins_beneficiaries.comments is 'Коменты';
comment on column fos.ins_beneficiaries.cu is 'Крайний изменивший';
comment on column fos.ins_beneficiaries.cd is 'Крайняя дата изменений';
comment on column fos.ins_beneficiaries.ct is 'Терминал';
comment on column fos.ins_beneficiaries.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.ins_beneficiaries
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
