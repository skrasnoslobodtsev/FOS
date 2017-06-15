--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 21.05.2017
    Purpose   : Справочник адресов контрагентов

Change list:
21.05.2017 Перепечко А.В. Переносим на pg
*/
--if OBJECT_ID( 'dbo.[contragent_addresses]', 'U') is NOT NULL
--  drop table dbo.contragent_addresses;
drop table fos.contragent_addresses cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        contragent_id       - Ссылка на контрагента
        kind_id             - Ссылка на вид адреса, справочник dbo.dict_enum_items (юр.адрес, факт.адрес)

        country_id          - Ссылка на страну
        city_id             - Ссылка на город

        -- Атрибуты
        post_index          - Почтовый индекс
        country_name        - Страна
        area_name           - республика, край, область, округ
        street_kind_name    - Вид улицы ( улица, тупик, переулок, etc.)
        street_name         - Улица
        house_number        - Номер дома
        building1           - Корпус
        building2           - Строение
        address             - Адрес полностью
        active_flag         - Признак активности адреса: 0 - нет, 1 (default) - да
        primary_flag        - Признак основного адреса: 0 (default) - нет, 1 - да

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        change_user         - Пользователь
        chnage_date         - Дата последнего изменения
        change_term         - Терминал
        change_user_id      - Ссылка на юзверя
*/
create table fos.contragent_addresses
(
    id                  bigint          NOT NULL,
    -- Ссылки
    contragent_id       bigint          NOT NULL,
    kind_id             bigint          NOT NULL,

    country_id          bigint          NULL,
    city_id             bigint          NULL,

    -- Атрибуты
    post_index          nvarchar(50)    NULL,
    country_name        nvarchar(100)   NULL,
    area_name           nvarchar(100)   NULL,
    street_kind_name    nvarchar(100)   NULL,
    street_name         nvarchar(100)   NULL,
    house_number        nvarchar(50)    NULL,
    building1           nvarchar(50)    NULL,
    building2           nvarchar(50)    NULL,
    [address]           nvarchar(1000)  NULL,
    active_flag         int             NOT NULL default 1,
    primary_flag        int             NOT NULL default 0,

    -- Не обязательные, но тоже есть у всех
    [description]       nvarchar(500)   NULL,
    comments            nvarchar(1000)  NULL,
    -- Системные
    change_user         nvarchar(256)   NOT NULL constraint contragent_addresses_df_cu default system_user,
    change_date         datetime        NOT NULL constraint contragent_addresses_df_cd default getdate(),
    change_term         nvarchar(256)   NOT NULL constraint contragent_addresses_dt_ct default host_name(),
    change_user_id      bigint          NULL,
    -- Ограничения
    constraint contragent_addresses_pk primary key nonclustered ( id),
    -- Внешний ключ
    constraint contragent_addresses_fk_contragent foreign key( contragent_id) references dbo.contragents( id),
    constraint contragent_addresses_fk_kind foreign key( kind_id) references dbo.dict_enum_items( id),
    constraint contragent_addresses_fk_country foreign key( country_id) references dbo.dict_countries( id),
    constraint contragent_addresses_fk_city foreign key( city_id) references dbo.dict_cities( id),
    constraint contragent_addresses_fk_cu_id foreign key( change_user_id) references dbo.sys_users( id),
    -- Уникальность
    -- Проверки
    constraint contragent_addresses_ch_af check( active_flag in ( 0, 1)),
    constraint contragent_addresses_ch_pf check( primary_flag in ( 0, 1))
)
go

grant select on dbo.contragent_addresses to public;
go

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
