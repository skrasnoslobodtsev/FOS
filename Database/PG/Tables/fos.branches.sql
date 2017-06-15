--use [template_db]
--go
/*
    Developer : Перепечко А.В.
    Created   : 16.03.2015
    Purpose   : Справочники общего назначения, филиалы, редактируются только power user

Change list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.branches', 'U') is NOT NULL
--    drop table dbo.branches;
drop table fos.branches cascade;
/*
    Атрибуты:
        id          - Уникальный идентификатор экземпляра
        country_id  - Ссылка на страну
        city_id     - Ссылка на город
        nat_currency_id - Ссылка на НВ (национальная валюта)
        name        - Наименование филиала
        description - Описание
        comments    - Коментарии
*/
create table fos.branches
(
    id              bigint          NOT NULL,
    country_id      bigint          NOT NULL,
    city_id         bigint          NULL,
    nat_currency_id bigint          NULL,
    code            varchar(50)     NOT NULL,
    name            varchar(100)    NOT NULL,
    description     varchar(500)    NULL,
    comments        varchar(1000)   NULL,
    -- system info
    change_user     varchar(256)    NOT NULL default session_user,
    change_date     timestamp       NOT NULL default current_timestamp,
    change_term     varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id  bigint          NULL,
    -- constraints ---------------------------------------------
    constraint branches_pk primary key (id),
    constraint branches_fk_country foreign key (country_id) references fos.dict_countries(id),
    constraint branches_fk_city foreign key ( city_id) references fos.dict_cities(id),
    constraint branches_fk_cu_id foreign key( change_user_id) references fos.sys_users( id),
    constraint branches_uk_code unique ( code)
)
;

grant select on fos.branches to public;
grant select on fos.branches to fos_public;

comment on table fos.branches is 'Филиалы';

comment on column fos.branches.id is 'Уникальный идентификатор экземпляра';
comment on column fos.branches.country_id is 'Ссылка на страну';
comment on column fos.branches.city_id is 'Ссылка на город';
comment on column fos.branches.nat_currency_id is 'Ссылка на нац.валюту';
comment on column fos.branches.code is 'Код';
comment on column fos.branches.name is 'Наименование';
comment on column fos.branches.description is 'Описание';
comment on column fos.branches.comments is 'Коменты';
comment on column fos.branches.change_user is 'Изменил';
comment on column fos.branches.change_date is 'Изменили';
comment on column fos.branches.change_term is 'Терминал';
comment on column fos.branches.change_user_id is 'Пользователь';

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