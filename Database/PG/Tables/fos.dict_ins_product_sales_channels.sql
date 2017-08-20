--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 17.08.2017
    Purpose   : Страхование, доступные каналы продаж страхового продукта

Change list:
17.08.2017 Перепечко А.В. Переносим на PG
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.dict_ins_product_sales_channels', 'U') is NOT NULL
--    drop table dbo.dict_ins_product_sales_channels;
--go
drop table fos.dict_ins_product_sales_channels;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        
        -- Links
        ins_product_id          - Ссылка на страховой продукт
        ins_sales_channel_id    - Ссылка на канал продаж ( dbo.dict_enum_items)

        -- Attributes
        
        -- description and comments
        description         - Описание
        comments            - Коментарии
        
        -- system info
        cu                  - Последний изменивший
        cd                  - Последняя дата изменений
        ct                  - Терминал
        cu_id               - Пользователь
*/
create table fos.dict_ins_product_sales_channels
(
    id                      bigint          NOT NULL,
    
    -- fk here
    ins_product_id          bigint          NOT NULL,
    ins_sales_channel_id    bigint          NOT NULL,
    
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
    constraint dict_ins_product_sales_channels_pk primary key ( id),
    -- links
    constraint dict_ins_product_sales_channels_fk_ins_product foreign key( ins_product_id) references fos.dict_ins_products( id),
    constraint dict_ins_product_sales_channels_fk_ins_sales_channel_id foreign key( ins_sales_channel_id) references fos.dict_enum_items( id),
    constraint dict_ins_product_sales_channels_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- unique --------------------------------------------------
    constraint dict_ins_product_sales_channels_uk unique( ins_product_id, ins_sales_channel_id)
);

grant select on fos.dict_ins_product_sales_channels to public;
grant select on fos.dict_ins_product_sales_channels to fos_public;

comment on table fos.dict_ins_product_sales_channels is 'Страхование, доступные каналы продаж страхового продукта';

comment on column fos.dict_ins_product_sales_channels.id is '';
comment on column fos.dict_ins_product_sales_channels.ins_product_id is '';
comment on column fos.dict_ins_product_sales_channels.ins_sales_channel_id is '';
comment on column fos.dict_ins_product_sales_channels.description is '';
comment on column fos.dict_ins_product_sales_channels.comments is '';
comment on column fos.dict_ins_product_sales_channels.cu is '';
comment on column fos.dict_ins_product_sales_channels.cd is '';
comment on column fos.dict_ins_product_sales_channels.ct is '';
comment on column fos.dict_ins_product_sales_channels.cu_id is '';

/*  
-- SQL запросы
select
    *
from
    dbo.dict_ins_product_sales_channels with (nolock)
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