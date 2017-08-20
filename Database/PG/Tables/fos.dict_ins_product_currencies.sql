--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 17.08.2017
    Purpose   : Страхование, доступные валюты в страховом продукте

Change list:
17.08.2017 Перепечко А.В. Переносим на PG
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.dict_ins_product_currencies', 'U') is NOT NULL
--    drop table dbo.dict_ins_product_currencies;
--go
drop table fos.dict_ins_product_currencies cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        
        -- Links
        ins_product_id      - Ссылка на страховой продукт
        currency_id         - Ссылка на валюту
        
        -- description and comments
        description         - Описание
        comments            - Коментарии
        
        -- system info
        cu                  - Последний изменивший
        cd                  - Последняя дата изменений
        ct                  - Терминал
        cu_id               - Пользователь
*/
create table fos.dict_ins_product_currencies
(
    id                      bigint          NOT NULL,
    
    -- fk here
    ins_product_id          bigint          NOT NULL,
    currency_id             bigint          NOT NULL,
    
    -- Атрибуты
    
    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,

    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,

    -- constraints ---------------------------------------------
    constraint dict_ins_product_currencies_pk primary key ( id),
    constraint dict_ins_product_currencies_fk_ins_product foreign key( ins_product_id) references fos.dict_ins_products( id),
    constraint dict_ins_product_currencies_fk_currency foreign key( currency_id) references fos.dict_currencies( id),
    constraint dict_ins_product_currencies_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- unique --------------------------------------------------
    constraint dict_ins_product_currencies_uk unique( ins_product_id, currency_id)
);

grant select on fos.dict_ins_product_currencies to public;
grant select on fos.dict_ins_product_currencies to fos_public;

comment on table fos.dict_ins_product_currencies is 'Страхование, доступные валюты в страховом продукте';

comment on column fos.dict_ins_product_currencies.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_product_currencies.ins_product_id is 'Ссылка на страховой продукт';
comment on column fos.dict_ins_product_currencies.currency_id is 'Ссылка на валюту';
comment on column fos.dict_ins_product_currencies.description is 'Описание';
comment on column fos.dict_ins_product_currencies.comments is 'Коменты';
comment on column fos.dict_ins_product_currencies.cu is 'Крайний изменивший';
comment on column fos.dict_ins_product_currencies.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_product_currencies.ct is 'Терминал';
comment on column fos.dict_ins_product_currencies.cu_id is 'Пользователь';

/*  
-- SQL запросы
select
    *
from
    dbo.dict_ins_product_currencies with (nolock)
;

select
  ErrorCode,
  ErrorMessage
from dbo.SysErrors with (NoLock)
order by ErrorCode desc

select
    *
from 
    dbo.sys_settings with (NoLock)
;

select
  *
from dbo.vDictionaries
order by 1, 4
*/