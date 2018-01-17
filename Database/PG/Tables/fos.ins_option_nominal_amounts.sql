/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 17.01.2018
    Purpose   : Объекты учёта, номинальные суммы опционов

Change list:
*/
drop table if exists fos.ins_option_nominal_amounts cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_option_id           - Ссылка на опцион
        amount_currency_kind_id - Ссылка на вид валюты (документа, базовой, национальной, etc., справочник fos.dict_enum_items:dict_ins_amount_currency_kinds)
        currency_id             - Ссылка на валюту (справочник fos.dict_currencies)
        rate_id                 - Ссылка на курс

        -- Атрибуты
        amount                  - Сумма

        -- Признаки

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты

        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.ins_option_nominal_amounts
(
    id                      bigint          NOT NULL,
    -- Ссылки
    ins_option_id           bigint          not null,
    amount_currency_kind_id bigint          not null,
    currency_id             bigint          not null,
    rate_id                 bigint          null,

    -- Атрибуты
    amount                  float           not null default 0.0,

    -- Признаки

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------

    constraint ins_option_nominal_amounts_pk primary key ( id),
    -- Ссылки
    constraint ins_option_nominal_amounts_fk_ins_option foreign key( ins_option_id) references fos.ins_options( id),
    constraint ins_option_nominal_amounts_fk_amount_currency_kind foreign key( amount_currency_kind_id) references fos.dict_enum_items( id),
    constraint ins_option_nominal_amounts_fk_currency_id foreign key( currency_id) references fos.dict_currencies( id),
    constraint ins_option_nominal_amounts_fk_rate foreign key ( rate_id) references fos.dict_rates( id),
    constraint ins_option_nominal_amounts_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Ссылки на версии
    -- Уникальность
    constraint ins_option_nominal_amounts_uk unique( ins_option_id, amount_currency_kind_id)
    -- Проверки
);

grant select on fos.ins_option_nominal_amounts to public;
grant select on fos.ins_option_nominal_amounts to fos_public;

comment on table fos.ins_option_nominal_amounts is 'Объекты учёта, номинальные суммы опционов';

comment on column fos.ins_option_nominal_amounts.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_option_nominal_amounts.ins_option_id is 'Ссылка на опцион';
comment on column fos.ins_option_nominal_amounts.amount_currency_kind_id is 'Ссылка на вид валюты (документа, базовой, национальной, etc., справочник fos.dict_enum_items:dict_ins_amount_currency_kinds)';
comment on column fos.ins_option_nominal_amounts.currency_id is 'Ссылка на валюту';
comment on column fos.ins_option_nominal_amounts.rate_id is 'Ссылка на курс';
comment on column fos.ins_option_nominal_amounts.amount is 'Сумма';
comment on column fos.ins_option_nominal_amounts.description is 'Описание';
comment on column fos.ins_option_nominal_amounts.comments is 'Коменты';
comment on column fos.ins_option_nominal_amounts.cu is 'Крайний изменивший';
comment on column fos.ins_option_nominal_amounts.cd is 'Крайняя дата изменений';
comment on column fos.ins_option_nominal_amounts.ct is 'Терминал';
comment on column fos.ins_option_nominal_amounts.cu_id is 'Пользователь';
/*
-- Проверка
select
    *
from
    fos.ins_option_nominal_amounts
;

-- SQL запросы 
select
    error_code,
    error_message
from 
    fos.sys_errors
order by 
    error_code desc
;

select
    *
from 
    fos.sys_settings
;

select
    *
from 
    fos.vDictionaries
order by 
    1, 
    4
*/

