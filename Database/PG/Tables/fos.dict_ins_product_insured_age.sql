--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 17.08.2017
    Purpose   : Страхование, доступный возраст застрахованнного

Change list:
17.08.2017 Перепечко А.В. Переносим на PG
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.dict_ins_product_insured_age', 'U') is NOT NULL
--    drop table dbo.dict_ins_product_insured_age;
--go
drop table fos.dict_ins_product_insured_age cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        
        -- Links
        ins_product_id      - Ссылка на страховой продукт

        -- Attributes
        age_months          - Возраст застрахованного в месяцах
        primary_flag        - Признак основного застрахованного: 0 (default) - нет, 1 - да
        
        -- description and comments
        description         - Описание
        comments            - Коментарии
        
        -- system info
        cu                  - Последний изменивший
        cd                  - Последняя дата изменений
        ct                  - Терминал
        cu_id               - Пользователь
*/
create table fos.dict_ins_product_insured_age
(
    id                      bigint          NOT NULL,
    
    -- fk here
    ins_product_id          bigint          NOT NULL,
    
    -- Атрибуты
    age_months              int             NOT NULL,
    primary_flag            int             NOT NULL default 0,
    
    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    
    -- constraints ---------------------------------------------
    constraint dict_ins_product_insured_age_pk primary key ( id),
    -- links
    constraint dict_ins_product_insured_age_fk_ins_product foreign key( ins_product_id) references fos.dict_ins_products( id),
    constraint dict_ins_product_insured_age_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- unique --------------------------------------------------
    constraint dict_ins_product_insured_age_uk unique( ins_product_id, age_months, primary_flag),
    -- checks
    constraint dict_ins_product_insured_age_ch_age check( age_months > 0),
    constraint dict_ins_product_insured_age_ch_pf check( primary_flag in ( 0, 1))
);

grant select on fos.dict_ins_product_insured_age to public;
grant select on fos.dict_ins_product_insured_age to fos_public;

comment on table fos.dict_ins_product_insured_age is 'Страхование, доступный возраст застрахованнного';

comment on column fos.dict_ins_product_insured_age.id is 'Уникальный идентификатор экземпляра'; 
comment on column fos.dict_ins_product_insured_age.ins_product_id is 'Ссылка на страховой продукт'; 
comment on column fos.dict_ins_product_insured_age.age_months is 'Возраст в месяцах'; 
comment on column fos.dict_ins_product_insured_age.primary_flag is 'Признак основного застрахованного: 0 (default) - нет, 1 - да'; 
comment on column fos.dict_ins_product_insured_age.description is 'Описание'; 
comment on column fos.dict_ins_product_insured_age.comments is 'Коменты'; 
comment on column fos.dict_ins_product_insured_age.cu is 'Крайний изменивший'; 
comment on column fos.dict_ins_product_insured_age.cd is 'Крайняя дата изменений'; 
comment on column fos.dict_ins_product_insured_age.ct is 'Терминал'; 
comment on column fos.dict_ins_product_insured_age.cu_id is 'Пользователь'; 

/*  
-- SQL запросы
select
    *
from
    dbo.dict_ins_product_insured_age with (nolock)
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