--use [template_db]
--go
/*
    Developer : Перепечко А.В.
    Created   : 17.03.2015
    Purpose   : Справочники общего назначения, валюты, редактируются только power user

Change list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.dict_currencies', 'U') is NOT NULL
--    drop table dbo.dict_currencies;
drop table fos.dict_currencies cascade;
/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        name            - Наименование валюты
        iso_code        - ISO код валюты
        num_code        - Цифро код валюты
        sign            - Обозначение
        country_name    - Наименование страны
        code            - Код
        description     - Описание
        comments        - Коментарии
        cu              - Последний изменивший
        cd              - Последняя дата изменений
        ct              - Терминал
        cu_id           - Ссылка на пользователя
*/
create table fos.dict_currencies
(
    id                  bigint          NOT NULL,
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    iso_code            varchar(50)     NOT NULL,
    num_code            varchar(50)     NOT NULL,
    sign                varchar(50)     NULL,
    country_name        varchar(100)    NULL,
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- ---
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- ---------------------------------------------------------
    constraint dict_currencies_pk primary key(id),
    constraint dict_currencies_uk_iso unique(iso_code),
    constraint dict_currencies_uk_num unique(num_code),
    constraint dict_currencies_uk_code unique( code),
    constraint dict_currencies_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
)
;

create index dict_currencies_idx_id on fos.dict_currencies( id);
create index dict_currencies_idx_code on fos.dict_currencies( code);

grant select on fos.dict_currencies to public;
grant select on fos.dict_currencies to fos_public;

comment on table fos.dict_currencies is 'Справочник валют';

comment on column fos.dict_currencies.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_currencies.code is 'Код (iso_code)';
comment on column fos.dict_currencies.name is 'Наименование';
comment on column fos.dict_currencies.iso_code is 'iso код 3 буквы';
comment on column fos.dict_currencies.num_code is 'цифро код 3 цифры';
comment on column fos.dict_currencies.sign is 'Обозначение';
comment on column fos.dict_currencies.country_name is 'Наименование страны';
comment on column fos.dict_currencies.description is 'Описание';
comment on column fos.dict_currencies.comments is 'Коментарии';
comment on column fos.dict_currencies.cu is 'Изменил';
comment on column fos.dict_currencies.cd is 'Изменили';
comment on column fos.dict_currencies.ct is 'Терминал';
comment on column fos.dict_currencies.cu_id is 'Пользователь';
/*  
-- SQL запросы
select
  ErrorCode,
  ErrorMessage
from dbo.SysErrors with (NoLock)
order by ErrorCode desc

select
  *
from dbo.SysSettings with (NoLock)

select
  *
from dbo.vDictionaries
order by 1, 4
*/