--use [template_db]
--go
/*
    Developer : Перепечко А.В.
    Created   : 16.03.2015
    Purpose   : Справочник стран

Chnage list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
07.10.2017 Перепечко А.В. Добавляем ссылки на корень, след и пред версии, признак удаления
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'fos.dict_countries', 'U') is NOT NULL
--    drop table fos.dict_countries;
drop table fos.dict_countries cascade;
/*
    Атрибуты:
        id              - ID связи

        name            - Наименование
        code_2          - Код 2
        code_3          - Код 3
        code_number     - Цифрокод

        -- Не обязательные, но тоже есть у всех
        delete_flag         - Признак удаления сущности: 0 (default) - нет, 1 - да
        description     - Описание
        comments        - Коментарии
        code            - Код

        -- Системные
        cu              - Последний изменивший
        cd              - Дата изменения
        ct              - Терминал
        cu_id           - Ссылка на пользователя
*/
create table fos.dict_countries
(
    id                  bigint          NOT NULL,
    -- Ссылки
    root_id             bigint          not null,
    prior_version_id    bigint          null,
    next_version_id     bigint          null,
    -- Атрибуты
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    code_2              varchar(50)     NOT NULL,
    code_3              varchar(50)     NOT NULL,
    code_number         varchar(50)     NOT NULL,
    -- Не обязательные, но тоже есть у всех
    delete_flag         int             not null default 0,
    description         varchar(500)    NOT NULL,
    comments            varchar(1000)   NULL,
    -- ------
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- --------------------------------------
    constraint dict_countries_pk primary key (id),
    constraint dict_countries_uk unique (code_3),
    constraint dict_countries_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
)
;

alter table
    fos.dict_countries
add 
    constraint dict_countries_fk_root
    foreign key( root_id)
    references fos.dict_countries( id);

alter table 
    fos.dict_countries
add
    constraint dict_countries_fk_prior_version
    foreign key( prior_version_id)
    references fos.dict_countries( id);

alter table
    fos.dict_countries
add
    constraint dict_countries_fk_next_version
    foreign key( next_version_id)
    references fos.dict_countries( id);


create index dict_countries_idx_id on fos.dict_countries( id);
create index dict_countries_idx_code_3 on fos.dict_countries( code_3);
create index dict_countries_idx_code on fos.dict_countries(code);

grant select on fos.dict_countries to public;
grant select on fos.dict_countries to fos_public;

comment on table fos.dict_countries is 'Справочник стран';

comment on column fos.dict_countries.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_countries.root_id is 'Ссылка на корневую версию';
comment on column fos.dict_countries.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.dict_countries.next_version_id is 'Ссылка на следующую версию';
comment on column fos.dict_countries.name is 'Наименование';
comment on column fos.dict_countries.code is 'Код (code_3)';
comment on column fos.dict_countries.code_2 is 'Код 2 буквы';
comment on column fos.dict_countries.code_3 is 'Код 3 буквы';
comment on column fos.dict_countries.code_number is 'Код цифры';
comment on column fos.dict_countries.delete_flag is 'Признак удаления сущности: 0 (default) - нет, 1 - да';
comment on column fos.dict_countries.description is 'Описание';
comment on column fos.dict_countries.comments is 'Коментарии';
comment on column fos.dict_countries.cu is 'Изменил';
comment on column fos.dict_countries.cd is 'Изменили';
comment on column fos.dict_countries.ct is 'Терминал';
comment on column fos.dict_countries.cu_id is 'Пользователь';

/*

select
    *
from
    fos.dict_countries
;

-- SQL запросы
select
  ErrorCode,
  ErrorMessage
from fos.SysErrors with (NoLock)
order by ErrorCode desc

select
  *
from fos.SysSettings with (NoLock)

select
  *
from fos.vDictionaries
order by 1, 4

select
    *
from
    dict_countries

select
    current_user,
    system_user
*/