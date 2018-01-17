--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 26.10.2016
    Purpose   : Страхование, справочник правил страхования, един для всех

Change list:
04.08.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
04.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.[dict_ins_rules]', 'U') is NOT NULL
--    drop table dbo.[dict_ins_rules];
drop table if exists fos.dict_ins_rules cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        -- ..

        -- Атрибуты
        code                - Код
        name                - Наименование
        data                - Текст правил

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.dict_ins_rules
(
    id                  bigint          NOT NULL,
    -- Ссылки
    root_id             bigint          null,
    prior_version_id    bigint          null,
    next_version_id     bigint          null,

    -- Атрибуты
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    data                varchar         NULL,

    -- description and comments    
    delete_flag         int             not null default 0,
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,

    -- Ограничения
    constraint dict_ins_rules_pk primary key ( id),
    -- Ссылки
    constraint dict_ins_rules_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Версии
    constraint dict_ins_rules_fk_root foreign key( root_id) references fos.dict_ins_rules( id),
    constraint dict_ins_rules_fk_prior_version foreign key( prior_version_id) references fos.dict_ins_rules( id),
    constraint dict_ins_rules_fk_next_version foreign key( next_version_id) references fos.dict_ins_rules( id),
    -- Уникальность
--    constraint dict_ins_rules_uk unique( code),
    -- Проверки
    constraint dict_ins_rules_ch_df check( delete_flag in ( 0, 1))
);

grant select on fos.dict_ins_rules to public;
grant select on fos.dict_ins_rules to fos_public;

comment on table fos.dict_ins_rules is 'Страхование, справочник правил страхования';

comment on column fos.dict_ins_rules.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_rules.root_id is 'Ссылка на корневую версию';
comment on column fos.dict_ins_rules.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.dict_ins_rules.next_version_id is 'Ссылка на следующую версию';
comment on column fos.dict_ins_rules.code is 'Код';
comment on column fos.dict_ins_rules.name is 'Наименование';
comment on column fos.dict_ins_rules.data is 'Текст правил';
comment on column fos.dict_ins_rules.description is 'Описание';
comment on column fos.dict_ins_rules.comments is 'Коменты';
comment on column fos.dict_ins_rules.cu is 'Крайний изменивший';
comment on column fos.dict_ins_rules.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_rules.ct is 'Терминал';
comment on column fos.dict_ins_rules.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.dict_ins_rules with (nolock)
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
    dbo.v_dicts_enums
order by 
    1, 
    4
*/
