--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 29.11.2016
    Purpose   : Страхование, связь серий и продуктов, многие ко многим
                делаем из-за мудовой ситуации, когда одна серия принадлежит нескольким продуктам, 
                различия в программах страхования

Change list:
04.08.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
04.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_product_ins_series', 'U') is NOT NULL
--    drop table dbo.dict_ins_product_ins_series;
drop table fos.dict_ins_product_ins_series cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_product_id      - Ссылка на продукт
        ins_serie_id        - Ссылка на серию

        -- Атрибуты
        -- ..

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.dict_ins_product_ins_series
(
    id                  bigint          NOT NULL,
    -- Ссылки
    ins_product_id      bigint          NOT NULL,
    ins_serie_id        bigint          NOT NULL,

    -- Атрибуты

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,

    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,

    -- constraints ---------------------------------------------
    constraint dict_ins_product_ins_series_pk
        primary key ( id),
    -- Ссылки
    constraint dict_ins_product_ins_series_fk_ins_product  
        foreign key( ins_product_id) references fos.dict_ins_products( id),
    constraint dict_ins_product_ins_series_fk_ins_serie
        foreign key( ins_serie_id) references fos.dict_ins_series( id),
    constraint dict_ins_product_ins_series_fk_cu_id
        foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint dict_ins_product_ins_series_uk
        unique( ins_product_id, ins_serie_id)
);

grant select on fos.dict_ins_product_ins_series to public;
grant select on fos.dict_ins_product_ins_series to fos_public;

comment on table fos.dict_ins_product_ins_series is 'Страхование, связь продукта и серий';

comment on column fos.dict_ins_product_ins_series.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_product_ins_series.ins_product_id is 'Ссылка на продукт';
comment on column fos.dict_ins_product_ins_series.ins_serie_id is 'Ссылка на серию';
comment on column fos.dict_ins_product_ins_series.description is 'Описание';
comment on column fos.dict_ins_product_ins_series.comments is 'Коменты';
comment on column fos.dict_ins_product_ins_series.cu is 'Крайний изменивший';
comment on column fos.dict_ins_product_ins_series.cd is 'Крайняя дата изменения';
comment on column fos.dict_ins_product_ins_series.ct is 'Терминал';
comment on column fos.dict_ins_product_ins_series.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.dict_ins_product_ins_series
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
;

select
  *
from dbo.vDictionaries
order by 1, 4;
*/
