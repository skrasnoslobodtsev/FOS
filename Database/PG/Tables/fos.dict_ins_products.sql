--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 01.07.2016
    Purpose   : Страхование, справочник продуктов

Change list:
24.11.2016 Перепечко А.В. Переводим в разряд пополняемых справочников предметной области
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
31.07.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
03.08.2017 Перепечко А.В. Переносим на PG
24.12.2017 Перепечко А.В. Добавляем признаки пенсии и инвестиций
*/
--if OBJECT_ID( 'dbo.[dict_ins_products]', 'U') is NOT NULL
--    drop table dbo.dict_ins_products;
--go
drop table if exists fos.dict_ins_products cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        branch_id               - Ссылка на филиал
        root_id                 - Ссылка на первую версию
        prior_version_id        - Ссылка на предыдущую версию
        next_version_id         - Ссылка на след.версию
        status_id               - Ссылка на статус продукта (простые справочники dbo.dict_enum_items)

        -- Атрибуты
        code                    - Код продукта
        name                    - Наименование продукта
        date_from               - Дата начала действия продукта
        date_till               - Дата окончания действия продукта
        def_grr                 - ГНД по умолчанию
        def_grr_date            - Дата действия ГНД

        -- Признаки
        active_flag             - Признак активности продукта, 0 (default) - нет, 1 - да
        surrender_values_flag   - Признак наличия выкупных сумм, 0 (default) - нет, 1 - да
        pension_flag            - Признак выплаты пенсии/ренты: 0 (default) - нет, 1 - да
        investment_flag         - Признак участия в инвестициях: 0 (default) - нет, 1 - да

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты

        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.dict_ins_products
(
    id                      bigint          NOT NULL,
    -- Ссылки
    branch_id               bigint          NULL,
    root_id                 bigint          NULL,
    prior_version_id        bigint          NULL,
    next_version_id         bigint          NULL,
    status_id               bigint          NULL,

    -- Атрибуты
    code                    varchar(50)     NOT NULL,
    name                    varchar(100)    NOT NULL,
    date_from               timestamp       NULL,
    date_till               timestamp       NULL,
    def_grr                 float           NULL,
    def_grr_date            timestamp       NULL,

    -- Признаки
    active_flag             int             NOT NULL default 0,
    surrender_values_flag   int             NOT NULL default 0,

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------

    constraint dict_ins_products_pk
        primary key ( id),
    -- Ссылки
    constraint dict_ins_products_fk_branch
        foreign key( branch_id) references fos.branches( id),
    constraint dict_ins_products_fk_status
        foreign key( status_id) references fos.dict_enum_items( id),
    constraint dict_ins_products_fk_cu_id
        foreign key( cu_id) references fos.sys_users( id),
    -- Ссылки на версии
    constraint dict_ins_products_fk_root
        foreign key( root_id) references fos.dict_ins_products( id),
    constraint dict_ins_products_fk_prior_version
        foreign key( prior_version_id) references fos.dict_ins_products( id),
    constraint dict_ins_products_fk_next_version
        foreign key( next_version_id) references fos.dict_ins_products( id),
    -- Уникальность
--    constraint dict_ins_products_uk
--        unique( branch_id, name),
    -- Проверки
    constraint dict_ins_products_ch_af
        check( active_flag in ( 0, 1)),
    constraint dict_ins_products_ch_svf
        check( surrender_values_flag in ( 0, 1)),
    constraint dict_ins_products_ch_def_grr
        check( ( def_grr is null) or ( def_grr >= 0.0))
);

grant select on fos.dict_ins_products to public;
grant select on fos.dict_ins_products to fos_public;

comment on table fos.dict_ins_products is 'Страхование, справочник продуктов';

comment on column fos.dict_ins_products.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_products.branch_id is 'Ссылка на филиал';
comment on column fos.dict_ins_products.root_id is 'Ссылка на корневую версию';
comment on column fos.dict_ins_products.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.dict_ins_products.next_version_id is 'Ссылка на следующую версию';
comment on column fos.dict_ins_products.status_id is 'Ссылка на статус';
comment on column fos.dict_ins_products.code is 'Код';
comment on column fos.dict_ins_products.name is 'Наименование';
comment on column fos.dict_ins_products.date_from is 'Дата начала продаж';
comment on column fos.dict_ins_products.date_till is 'Дата окончания продаж';
comment on column fos.dict_ins_products.def_grr is 'ГНД по умолчанию';
comment on column fos.dict_ins_products.def_grr_date is 'Дата ГНД по умолчанию';
comment on column fos.dict_ins_products.active_flag is 'Признак активности, 0 (default) - нет, 1 - да';
comment on column fos.dict_ins_products.surrender_values_flag is 'Признак наличия выкупных сумм, 0 (default) нет, 1 - да';
comment on column fos.dict_ins_products.description is 'Описание';
comment on column fos.dict_ins_products.comments is 'Коменты';
comment on column fos.dict_ins_products.cu is 'Крайний изменивший';
comment on column fos.dict_ins_products.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_products.ct is 'Терминал';
comment on column fos.dict_ins_products.cu_id is 'Пользователь';
/*
-- Проверка
select
    *
from
    fos.dict_ins_products
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

