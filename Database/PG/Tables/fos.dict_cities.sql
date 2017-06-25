--use [template_db]
--go
/*
    Developer : Перепечко А.В.
    Created   : 16.03.2015
    Purpose   : Справочники общего назначения, города, редактируются только power user

Change list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.dict_cities', 'U') is NOT NULL
--    drop table dbo.dict_cities;
drop table fos.dict_cities cascade;
/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        country_id      - Ссылка на страну
        code            - Код (post_code)
        name            - Наименование
        post_code       - Почтовый индекс
        description     - Описание
        comments        - Коментарии
*/
create table fos.dict_cities
(
    id              bigint          NOT NULL,
    country_id      bigint          NULL,
    code            varchar(50)     NOT NULL,
    name            varchar(100)    NOT NULL,
    post_code       varchar(50)     NULL,
    description     varchar(500)    NULL,
    comments        varchar(1000)   NULL,
    -- ---
    cu              varchar(256)    NOT NULL default session_user,
    cd              timestamp       NOT NULL default current_timestamp,
    ct              varchar(256)    NOT NULL default inet_client_addr(),
    cu_id           bigint          NULL,
    -- -----------------------------------------------------------
    constraint dict_cities_pk primary key (id),
    constraint dict_cities_fk_country foreign key(country_id) references fos.dict_countries(id),
    constraint dict_cities_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
)
;

grant select on fos.dict_cities to public;
grant select on fos.dict_cities to fos_public;

comment on table fos.dict_cities is 'Справочник городов';

comment on column fos.dict_cities.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_cities.country_id is 'Ссылка на справочник стран';
comment on column fos.dict_cities.code is 'Код (post_code)';
comment on column fos.dict_cities.name is 'Наименование';
comment on column fos.dict_cities.post_code is 'Почтовый индекс';
comment on column fos.dict_cities.description is 'Описание';
comment on column fos.dict_cities.comments is 'Коментарии';
comment on column fos.dict_cities.cu is 'Изменил';
comment on column fos.dict_cities.cd is 'Изменили';
comment on column fos.dict_cities.ct is 'Терминал';
comment on column fos.dict_cities.cu_id is 'Пользователь';

/*  

select
    *
from
    fos.dict_cities
;

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