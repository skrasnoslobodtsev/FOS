--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 25.11.2016
    Purpose   : Связь продукта и возможных типов контрагентов страхователей
                Физическая многие ко многим, логическая один ко многим
                Используется для проверок типа контрагента страхователя

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
04.08.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
04.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_product_insurer_types', 'U') is NOT NULL
--    drop table dbo.dict_ins_product_insurer_types;
drop table fos.dict_ins_product_insurer_types cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_product_id      - Ссылка на продукт
        contragent_type_id  - Ссылка на тип контрагента, простой справочник contragent_types

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
create table fos.dict_ins_product_insurer_types
(
    id                  bigint          NOT NULL,
    -- Ссылки
    ins_product_id      bigint          NOT NULL,
    contragent_type_id  bigint          NOT NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,

    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,

    -- constraints ---------------------------------------------
    constraint dict_ins_product_insurer_types_pk
        primary key ( id),
    -- Ссылки
    constraint dict_ins_product_insurer_types_fk_ins_product
        foreign key( ins_product_id) references fos.dict_ins_products( id),
    constraint dict_ins_product_insurer_types_fk_contragent_type
        foreign key( contragent_type_id) references fos.dict_enum_items( id),
    constraint dict_ins_product_fk_cu_id
        foreign key( cu_id) references fos.sys_users( id)
);

grant select on fos.dict_ins_product_insurer_types to public;
grant select on fos.dict_ins_product_insurer_types to fos_public;

comment on table fos.dict_ins_product_insurer_types is 'Страхование, связь продукта и типов страхователей';

comment on column fos.dict_ins_product_insurer_types.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_product_insurer_types.ins_product_id is 'Ссылка на продукт';
comment on column fos.dict_ins_product_insurer_types.contragent_type_id is 'Ссылка на тип контрагента';
comment on column fos.dict_ins_product_insurer_types.description is 'Описание';
comment on column fos.dict_ins_product_insurer_types.comments is 'Коменты';
comment on column fos.dict_ins_product_insurer_types.cu is 'Крайний изменивший';
comment on column fos.dict_ins_product_insurer_types.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_product_insurer_types.ct is 'Терминал';
comment on column fos.dict_ins_product_insurer_types.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.[table_name]
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
