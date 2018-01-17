--use template_db
--go
/*
    Developer : Перепечко А.В.
    Created   : 09.03.2017
    Purpose   : Справочник перечисление (группировка)
                С признаком system_flag = 1 редактируются только разработчиком
                Остальные редактируемы power user

Change list:
04.05.2017 Перепечко А.В. Переносим на PG
14.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
06.10.2017 Перепечко А.В. Добавляем ссылки на корень, след и пред версии, признак удаления
30.10.2017 Перепечко А.В. Добавляем номер версии
30.11.2017 Перепечко А.В. Убираем номер версии
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.dict_enums', 'U') is NOT NULL
--    drop table dbo.dict_enums;
drop table if exists fos.dict_enums cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        branch_id           - Ссылка на филиал
        root_id             - Ссылка на корневую версию
        prior_version_id    - Ссылка на предыдущую версию
        next_version_id     - Ссылка на следующую версию
        -- Атрибуты
        code                - Код
        name                - Наименование
        -- Не обязательные, но тоже есть у всех
--        version_index       - Номер версии
        delete_flag         - Признак удаления сущности: 0 (default) - нет, 1 - да
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Последний изменивший
        cd                  - Последняя дата изменений
        ct                  - Терминал
        cu_id               - Ссылка на пользователя
*/
create table fos.dict_enums
(
    id                  bigint          NOT NULL,
    -- fk here
    branch_id           bigint          NULL,
    root_id             bigint          not null,
    prior_version_id    bigint          null,
    next_version_id     bigint          null,
    -- attributes
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    system_flag         int             NOT NULL default 0,
    -- description and comments    
--    version_index       int             not null default 0,
    delete_flag         int             not null default 0,
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_enums_pk primary key (id),
    constraint dict_enums_fk_branch foreign key (branch_id) references fos.branches(id),
    constraint dict_enums_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
--    constraint dict_enums_uk_version unique( root_id, version_index),
--    constraint dict_enums_uk_code unique ( code, branch_id, version_index),
    constraint dict_enums_chk_sf check( system_flag in ( 0, 1)),
    constraint dict_enums_ch_df check( delete_flag in ( 0, 1))
)
;

alter table fos.dict_enums 
add 
    constraint dict_enums_fk_root
    foreign key( root_id) references fos.dict_enums( id);

alter table fos.dict_enums
add
    constraint dict_enums_fk_prior_version
    foreign key( prior_version_id) references fos.dict_enums( id);

alter table fos.dict_enums
add
    constraint dict_enums_fk_next_version
    foreign key( next_version_id) references fos.dict_enums( id);

create index dict_enums_idx_id on fos.dict_enums(id);
create index dict_enums_key_idx on fos.dict_enums( id, branch_id);

grant select on fos.dict_enums to public;
grant select on fos.dict_enums to fos_public;

comment on table fos.dict_enums is 'Справочник перечислений (группировка)';

comment on column fos.dict_enums.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_enums.branch_id is 'Ссылка на филиал';
comment on column fos.dict_enums.root_id is 'Ссылка на корневую версию';
comment on column fos.dict_enums.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.dict_enums.next_version_id is 'Ссылка на следующую версию';
comment on column fos.dict_enums.code is 'Код';
comment on column fos.dict_enums.name is 'Наименование';
comment on column fos.dict_enums.system_flag is 'Признак системного справочника: 0 (default) - нет, 1 - да';
--comment on column fos.dict_enums.version_index is 'Номер версии';
comment on column fos.dict_enums.delete_flag is 'Признак удаления сущности: 0 (default) - нет, 1 - да';
comment on column fos.dict_enums.description is 'Описание';
comment on column fos.dict_enums.comments is 'Коменты';
comment on column fos.dict_enums.cu is 'Изменил';
comment on column fos.dict_enums.cd is 'Изменили';
comment on column fos.dict_enums.ct is 'Терминал';
comment on column fos.dict_enums.cu_id is 'Пользователь';

/*  
-- SQL запросы
select
    *
from
    <table_name>;


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