--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 26.10.2016
    Purpose   : Страхование, справочник серий

Change list:
25.11.2016 Перепечко А.В. переносим в пополняемые справочники предметной области
31.07.2017 Перепечко А,В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
31.07.2017 Перепечко А,В. Убираем нафик все лишние атрибуты, просто перечисление серий
02.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_series', 'U') is NOT NULL
--    drop table dbo.dict_ins_series;
drop table if exists fos.dict_ins_series cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        branch_id           - Ссылка на филиал

        -- Атрибуты
        code                - Код
        name                - Наименование

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.dict_ins_series
(
    id                  bigint          NOT NULL,
    -- Ссылки
    branch_id           bigint          NULL,

    -- Атрибуты
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    -- Ограничения
    constraint dict_ins_series_pk
        primary key ( id),
    -- Ссылки
    constraint dict_ins_series_fk_branch
        foreign key( branch_id) references fos.branches( id),
    constraint dict_ins_series_fk_cu_id
        foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint dict_ins_series_uk
        unique( branch_id, code)
    -- Проверки
);

grant select on fos.dict_ins_series to public;
grant select on fos.dict_ins_series to fos_public;

comment on table fos.dict_ins_series is 'Страхование: справочник серий';

comment on column fos.dict_ins_series.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_series.branch_id is 'Ссылка на филиал';
comment on column fos.dict_ins_series.code is 'Код';
comment on column fos.dict_ins_series.name is 'Наименование';
comment on column fos.dict_ins_series.description is 'Описание';
comment on column fos.dict_ins_series.comments is 'Коментарии';
comment on column fos.dict_ins_series.cu is 'Крайний изменивший ';
comment on column fos.dict_ins_series.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_series.ct is 'Терминал';
comment on column fos.dict_ins_series.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.dict_ins_series with (nolock)
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
;

select
    *
from
    INFORMATION_SCHEMA.OBJECTS
;

*/
