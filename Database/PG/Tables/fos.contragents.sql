--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 03.06.2016
    Purpose   : Контрагенты, базовая таблица

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
05.05.2017 Перепечко А.В. Убираем адреса, выносим в отдельную таблицу, добиваем поля и описание
05.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.[contragents]', 'U') is NOT NULL
--    drop table dbo.[contragents];
drop table fos.contragents cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        type_id             - Ссылка на справочник типов контрагентов (справочник перечислений)( ю.л./ф.л.)

        -- Атрибуты
        name                - Наименование контрагента
        lat_name            - На латинице
        norm_name           - Нормализованное наименование (в верхнем регистре)
        norm_lat_name       - Нормализованное латинское наименование (в верхнем регистре)
        short_name          - Краткое наименование контрагента
        full_name           - Полное наименование контрагента
        itn                 - ИНН (индивидуальный налоговый номер)
        resident_flag       - Признак резидент РФ: 0 - нет, 1 (default) - да

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.contragents
(
    id                  bigint          NOT NULL,
    -- Ссылки
    type_id             bigint          NOT NULL,

    -- Атрибуты
    name                varchar(100)    NOT NULL,
    lat_name            varchar(100)    NULL,
    norm_name           varchar(100)    NOT NULL,
    norm_lat_name       varchar(100)    NULL,
    short_name          varchar(100)    NOT NULL,
    full_name           varchar(100)    NOT NULL,
    itn                 varchar(50)     NULL,
    resident_flag       int             NOT NULL default 1,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint contragents_pk primary key ( id),
    constraint contragents_fk_type foreign key( type_id) references fos.dict_enum_items( id),
    constraint contragents_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    constraint contragents_uk_itn unique ( itn),
    constraint contragents_ch_rf check( resident_flag in ( 0, 1))
)
;

create index contragents_idx_norm_name on fos.contragents( norm_name);

grant select on fos.contragents to public;
grant select on fos.contragents to fos_public;

comment on table fos.contragents is 'Контрагенты, базовая таблица';

comment on column fos.contragents.id is 'Уникальный идентификатор экземпляра';
comment on column fos.contragents.type_id is 'Тип, ссылка на справочник перечислений';
comment on column fos.contragents.name is 'Наименование';
comment on column fos.contragents.lat_name is 'Латинское наименование';
comment on column fos.contragents.norm_name is 'Нормализованное наименование (в верхнем регистре)';
comment on column fos.contragents.norm_lat_name is 'Нормализованное латинское наименование (в верхнем регистре)';
comment on column fos.contragents.short_name is 'Краткое наименование';
comment on column fos.contragents.full_name is 'Полное наименование';
comment on column fos.contragents.itn is 'ИНН';
comment on column fos.contragents.resident_flag is 'Признак резидент РФ: 0 - нет, 1 (default) - да';
comment on column fos.contragents.description is 'Описание';
comment on column fos.contragents.comments is 'Коменты';
comment on column fos.contragents.cu is 'Крайний изменивший';
comment on column fos.contragents.cd is 'Крайняя дата изменений';
comment on column fos.contragents.ct is 'Терминал';
comment on column fos.contragents.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.contragents
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
