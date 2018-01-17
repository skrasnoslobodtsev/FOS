--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 21.05.2017
    Purpose   : Справочник адресов контрагентов

Change list:
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.[contragent_addresses]', 'U') is NOT NULL
--  drop table dbo.contragent_addresses;
drop table if exists fos.contragent_addresses cascade;
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
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
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
    post_index          varchar(50)     NULL,
    country_name        varchar(100)    NULL,
    area_name           varchar(100)    NULL,
    street_kind_name    varchar(100)    NULL,
    street_name         varchar(100)    NULL,
    house_number        varchar(50)     NULL,
    building1           varchar(50)     NULL,
    building2           varchar(50)     NULL,
    address             varchar(1000)   NULL,
    active_flag         int             NOT NULL default 1,
    primary_flag        int             NOT NULL default 0,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint contragent_addresses_pk primary key ( id),
    -- Внешний ключ
    constraint contragent_addresses_fk_contragent foreign key( contragent_id) references fos.contragents( id),
    constraint contragent_addresses_fk_kind foreign key( kind_id) references fos.dict_enum_items( id),
    constraint contragent_addresses_fk_country foreign key( country_id) references fos.dict_countries( id),
    constraint contragent_addresses_fk_city foreign key( city_id) references fos.dict_cities( id),
    constraint contragent_addresses_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    -- Проверки
    constraint contragent_addresses_ch_af check( active_flag in ( 0, 1)),
    constraint contragent_addresses_ch_pf check( primary_flag in ( 0, 1))
)
;

grant select on fos.contragent_addresses to public;
grant select on fos.contragent_addresses to fos_public;

comment on table fos.contragent_addresses is 'Справочник адресов контрагентов';

comment on column fos.contragent_addresses.id is 'Уникальный идентификатор экземпляра';
comment on column fos.contragent_addresses.contragent_id is 'Ссылка на контрагента, fos.contragents';
comment on column fos.contragent_addresses.kind_id is 'Ссылка на вид адреса, fos.dict_enum_items (юр.адрес, факт.адрес)';
comment on column fos.contragent_addresses.country_id is 'Ссылка на страну, fos.dict_countries';
comment on column fos.contragent_addresses.city_id is 'Ссылка на город, fos.dict_cities';
comment on column fos.contragent_addresses.post_index is 'Почтовый индекс';
comment on column fos.contragent_addresses.country_name is 'Страна';
comment on column fos.contragent_addresses.area_name is 'республика, край, область, округ';
comment on column fos.contragent_addresses.street_kind_name is 'Вид улицы ( улица, тупик, переулок, etc.)';
comment on column fos.contragent_addresses.street_name is 'Улица';
comment on column fos.contragent_addresses.house_number is 'Номер дома';
comment on column fos.contragent_addresses.building1 is 'Корпус';
comment on column fos.contragent_addresses.building2 is 'Строение';
comment on column fos.contragent_addresses.address is 'Адрес целиком';
comment on column fos.contragent_addresses.active_flag is 'Признак активности адреса: 0 - нет, 1 (default) - да';
comment on column fos.contragent_addresses.primary_flag is 'Признак основного адреса: 0 (default) - нет, 1 - да';
comment on column fos.contragent_addresses.description is 'Описание';
comment on column fos.contragent_addresses.comments is 'Коменты';
comment on column fos.contragent_addresses.cu is 'Крайний изменивший';
comment on column fos.contragent_addresses.cd is 'Крайняя дата изменения';
comment on column fos.contragent_addresses.ct is 'Терминал';
comment on column fos.contragent_addresses.cu_id is 'Пользователь';


/*  
-- Проверка
select
    *
from
    fos.contragent_addresses
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
