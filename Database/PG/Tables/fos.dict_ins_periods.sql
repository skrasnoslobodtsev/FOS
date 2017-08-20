--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 16.08.2017
    Purpose   : Страхование, периоды страхования страхового продукта

Change list:
16.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_periods', 'U') is NOT NULL
--    drop table dbo.dict_ins_periods;
--go
drop table fos.dict_ins_periods cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_product_id          - Ссылка на продукт страхования

        -- Атрибуты
        code                    - Код
        name                    - Наименование
        months                  - Кол-во месяцев

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
create table fos.dict_ins_periods
(
    id                      bigint          NOT NULL,
    -- Ссылки
    ins_product_id          bigint          NOT NULL,

    -- Атрибуты
    code                    varchar(50)     NOT NULL,
    name                    varchar(100)    NOT NULL,
    months                  int             NOT NULL,

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
    constraint dict_ins_periods_pk primary key ( id),
    -- Ссылки
    constraint dict_ins_periods_fk_ins_product foreign key( ins_product_id) references fos.dict_ins_products( id),
    -- Уникальность
    constraint dict_ins_periods_uk unique( ins_product_id, months)
);

grant select on fos.dict_ins_periods to public;
grant select on fos.dict_ins_periods to fos_public;

comment on table fos.dict_ins_periods is 'Страхование, периоды страхования страхового продукта';

comment on column fos.dict_ins_periods.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_periods.ins_product_id is 'Ссылка на страховой продукт';
comment on column fos.dict_ins_periods.code is 'Код';
comment on column fos.dict_ins_periods.name is 'Наименование';
comment on column fos.dict_ins_periods.months is 'Кол-во месяцев';
comment on column fos.dict_ins_periods.description is 'Описание';
comment on column fos.dict_ins_periods.comments is 'Коменты';
comment on column fos.dict_ins_periods.cu is 'Крайний изменнивший';
comment on column fos.dict_ins_periods.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_periods.ct is 'Терминал';
comment on column fos.dict_ins_periods.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.dict_ins_periods
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
    fos.sys_settings
;

select
    *
from 
    dbo.vDictionaries
order by 1, 4
*/

