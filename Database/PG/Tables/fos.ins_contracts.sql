--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 01.07.2016
    Purpose   : Объекты учёта, договора страхования

Change list:
10.03.2017 Перепечко А.В. Допиливаем атрибуты объекта учёта "Договор страхования"
12.08.2017 Перепечко А.В. Допиливаем атрибуты
12.08.2017 Перепечко А.В. Переносим на PG
17.01.2018 Перепечко А.В. Допиливаем атрибуты
*/
--if OBJECT_ID( 'dbo.ins_contracts', 'U') is NOT NULL
--    drop table dbo.ins_contracts
--go
drop table if exists fos.ins_contracts cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        doc_currency_id         - Ссылка на валюту договора
        ins_product_id          - Ссылка на страховой продукт
        ins_program_id          - Ссылка на программу страхования
        payment_frequency_id    - Ссылка на периодичность оплаты, справочник периодичностей оплаты
        pay_frequency_id        - Ссылка на периодичность выплат (пенсия/рента), справочник периодичностей выплат
        state_id                - Ссылка на доп статус, dict_enum_items

        -- Атрибуты
        doc_serie               - Серия договора
        doc_date                - Дата заведения договора
        first_payment_date      - Дата первого платежа (нам)

        -- Признаки
        recurrent_flag          - Признак рекурентных платежей, 0 (default) - нет, 1 - да
        blocked_flag            - Блокировка договора, 0 (default) - нет, 1 - да
        reinsurance_flag        - Призанк перестрахования, 0 (default) - нет, 1 - да

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты
        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.ins_contracts
(
    id                      bigint          NOT NULL,
    -- Ссылки
    doc_currency_id         bigint          NOT NULL,
    ins_product_id          bigint          NULL,
    ins_program_id          bigint          NULL,
    payment_frequency_id    bigint          NULL,
    pay_frequency_id        bigint          null,
    state_id                bigint          NULL,

    -- Атрибуты
    doc_serie               varchar(50)     NOT NULL,
    doc_date                timestamp       NOT NULL,
    first_payment_date      timestamp       NULL,

    -- Признаки
    recurrent_flag          int             NOT NULL default 0,
    blocked_flag            int             NOT NULL default 0,
    reinsurance_flag        int             NOT NULL default 0,

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------
    constraint ins_contracts_pk primary key ( id),
    -- Ссылки
    constraint ins_contracts_fk_contract foreign key( id) references fos.contracts( id),
    constraint ins_contracts_fk_doc_currency foreign key( doc_currency_id) references fos.dict_currencies( id),
    constraint ins_contracts_fk_ins_product foreign key( ins_product_id) references fos.dict_ins_products( id),
    constraint ins_contracts_fk_ins_program foreign key( ins_program_id) references fos.dict_ins_programs( id),
    constraint ins_contracts_fk_payment_frequency foreign key( payment_frequency_id) references fos.dict_ins_payment_frequencies( id),
    constraint ins_contracts_fk_pay_frequency_id foreign key( pay_frequency_id) references fos.dict_ins_pay_frequencies( id),
    constraint ins_contracts_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Ограничения проверки
    constraint ins_contracts_ch_rf check( recurrent_flag in ( 0, 1)),
    constraint ins_contracts_ch_bf check( blocked_flag in ( 0, 1)),
    constraint ins_contracts_ch_rif check( reinsurance_flag in ( 0, 1))
);

grant select on fos.ins_contracts to public;
grant select on fos.ins_contracts to fos_public;

comment on table fos.ins_contracts is 'Объекты учёта, договора страхования';

comment on column fos.ins_contracts.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_contracts.doc_currency_id is 'Ссылка на валюту документа';
comment on column fos.ins_contracts.ins_product_id is 'Ссылка на страховой продукт';
comment on column fos.ins_contracts.ins_program_id is 'Ссылка на программу страхования';
comment on column fos.ins_contracts.payment_frequency_id is 'Ссылка на частоту оплаты';
comment on column fos.ins_contracts.sub_state_id is 'Ссылка на доп.статус договора';
comment on column fos.ins_contracts.doc_serie is 'Серия';
comment on column fos.ins_contracts.doc_date is 'Дата заведения';
comment on column fos.ins_contracts.first_payment_date is 'Дата первого платежа';
comment on column fos.ins_contracts.recurrent_flag is 'Признак рекуррентных платежей: 0 (default) - нет, 1 - да';
comment on column fos.ins_contracts.blocked_flag is 'Признак блокировки договора: 0 (default) - нет, 1 - да';
comment on column fos.ins_contracts.reinsurance_flag is 'Признак перестрахования: 0 (default) - нет, 1 - да';
comment on column fos.ins_contracts.description is 'Описание';
comment on column fos.ins_contracts.comments is 'Коменты';
comment on column fos.ins_contracts.cu is 'Крайний изменивший';
comment on column fos.ins_contracts.cd is 'Крайняя дата изменений';
comment on column fos.ins_contracts.ct is 'Терминал';
comment on column fos.ins_contracts.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.ins_contracts with (nolock)
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
    dbo.SysSettings with (NoLock)

select
  *
from dbo.vDictionaries
order by 1, 4
*/
