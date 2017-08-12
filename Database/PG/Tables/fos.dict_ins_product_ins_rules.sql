--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 25.11.2016
    Purpose   : Связь продукта и возможных правил страхования
                Физически многи ко многим, логически 1 ко многим

Change list:
04.08.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
04.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_product_ins_rules', 'U') is NOT NULL
--    drop table dbo.dict_ins_product_ins_rules;
drop table fos.dict_ins_product_ins_rules cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_product_id      - Ссылка на страховой продукт
        ins_rule_id         - Ссылка на правило страхования

        -- Атрибуты
        -- ..

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id                Ссылка на юзверя
*/
create table fos.dict_ins_product_ins_rules
(
    id                  bigint          NOT NULL,
    -- Ссылки
    ins_product_id      bigint          NOT NULL,
    ins_rule_id         bigint          NOT NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_ins_product_ins_rules_pk
        primary key ( id),
    -- Ссылки
    constraint dict_ins_product_ins_rules_fk_ins_product
        foreign key( ins_product_id) references fos.dict_ins_products( id),
    constraint dict_ins_product_ins_rules_fk_ins_rule
        foreign key( ins_rule_id) references fos.dict_ins_rules( id),
    constraint dict_ins_product_ins_rules_fk_cu_id
        foreign key( cu_id) references fos.sys_users( id)
);

grant select on fos.dict_ins_product_ins_rules to public;
grant select on fos.dict_ins_product_ins_rules to fos_public;

comment on table fos.dict_ins_product_ins_rules is 'Страхование, связь продукта и правил страхования';

comment on column fos.dict_ins_product_ins_rules.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_product_ins_rules.ins_product_id is 'Ссылка на продукт';
comment on column fos.dict_ins_product_ins_rules.ins_rule_id is 'Ссылка на правила страхования';
comment on column fos.dict_ins_product_ins_rules.description is 'Описание';
comment on column fos.dict_ins_product_ins_rules.comments is 'Коменты';
comment on column fos.dict_ins_product_ins_rules.cu is 'Крайний изменивший';
comment on column fos.dict_ins_product_ins_rules.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_product_ins_rules.ct is 'Терминал';
comment on column fos.dict_ins_product_ins_rules.cu_id is 'Пользователь';
/*  
-- Проверка
select
    *
from
    dbo.dict_ins_product_ins_rules with (nolock)
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
