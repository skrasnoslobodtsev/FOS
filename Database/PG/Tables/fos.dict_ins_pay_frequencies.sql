--use fos_db_dev;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 24.12.2017
    Purpose   : Страхование, справочник частот выплат (мы)

Cgange list:
24.12.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'fos.dict_ins_pay_frequencies', 'U') is NOT NULL
--    drop table fos.dict_ins_pay_frequencies;
--go
drop table if exists fos.dict_ins_pay_frequencies cascade;

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
        frequency           - Частота оплат за год
        month_period        - Периодичность в месяцах

        -- Не обязательные, но тоже есть у всех
        delete_flag         - Признак удаления сущности: 0 (default) - нет, 1 - да
        description         - Описание
        comments            - Коменты

        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.dict_ins_pay_frequencies
(
    id                  bigint          NOT NULL,
    -- Ссылки
    branch_id           bigint          NULL,
    root_id             bigint          null,
    prior_version_id    bigint          null,
    next_version_id     bigint          null,

    -- Атрибуты
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    frequency           int             NOT NULL,
    month_period        int             NOT NULL,

    -- description and comments
    delete_flag         int             not null default 0,
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_ins_pay_frequencies_pk primary key ( id),
    -- Ссылки
    constraint dict_ins_pay_frequencies_fk_branch foreign key ( branch_id) references fos.branches( id),
    constraint dict_ins_pay_frequencies_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
    -- Проверки
);

alter table fos.dict_ins_pay_frequencies
    add
        constraint dict_ins_pay_frequencies_fk_root 
        foreign key( root_id) references fos.dict_ins_pay_frequencies( id);

alter table fos.dict_ins_pay_frequencies
    add
        constraint dict_ins_pay_frequencies_fk_prior_version 
        foreign key( prior_version_id) references fos.dict_ins_pay_frequencies( id);

alter table fos.dict_ins_pay_frequencies
    add
        constraint dict_ins_pay_frequencies_fk_next_version
        foreign key( next_version_id) references fos.dict_ins_pay_frequencies( id);

grant select on fos.dict_ins_pay_frequencies to public;
grant select on fos.dict_ins_pay_frequencies to fos_public;

comment on table fos.dict_ins_pay_frequencies is 'Страхование, справочник частот выплат (мы)';

comment on column fos.dict_ins_pay_frequencies.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_pay_frequencies.branch_id is 'Ссылка на филиал';
comment on column fos.dict_ins_pay_frequencies.root_id is 'Ссылка на корневую версию';
comment on column fos.dict_ins_pay_frequencies.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.dict_ins_pay_frequencies.next_version_id is 'Ссылка на следующую версию';
comment on column fos.dict_ins_pay_frequencies.code is 'Код';
comment on column fos.dict_ins_pay_frequencies.name is 'Наименование';
comment on column fos.dict_ins_pay_frequencies.frequency is 'Частота';
comment on column fos.dict_ins_pay_frequencies.month_period is 'Периодичность в месяцах';
comment on column fos.dict_ins_pay_frequencies.description is 'Описание';
comment on column fos.dict_ins_pay_frequencies.comments is 'Коменты';
comment on column fos.dict_ins_pay_frequencies.cu is 'Крайний изменивший';
comment on column fos.dict_ins_pay_frequencies.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_pay_frequencies.ct is 'Терминал';
comment on column fos.dict_ins_pay_frequencies.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.dict_ins_pay_frequencies with (nolock)
;

-- SQL запросы 
select
    error_code,
    error_message
from 
    fos.sys_errors with (NoLock)
order by 
    error_code desc
;

select
    *
from 
    fos.sys_settings with (NoLock)

select
    *
from 
    fos.v_dicts
order by 
    1, 
    4
*/
