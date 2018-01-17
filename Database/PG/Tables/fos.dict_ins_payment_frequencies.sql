--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 12.08.2017
    Purpose   : Страхование, справочник частот оплаты (нам)

Change list:
12.08.2017 Перепечко А.В. Переносим на PG
24.12.2017 Перепечко А.В. Добавляем ссылки на корень, след и пред версии, признак удаления
*/
--if OBJECT_ID( 'dbo.dict_ins_payment_frequencies', 'U') is NOT NULL
--    drop table dbo.dict_ins_payment_frequencies;
--go
drop table if exists fos.dict_ins_payment_frequencies cascade;
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
create table fos.dict_ins_payment_frequencies
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

    constraint dict_ins_payment_frequencies_pk primary key ( id),
    -- Ссылки
    constraint dict_ins_payment_frequencies_fk_branch foreign key ( branch_id) references fos.branches( id),
    constraint dict_ins_payment_frequencies_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Проверки
    constraint dict_ins_payment_frequencies_ch_df check( delete_flag in ( 0, 1))
);

alter table fos.dict_ins_payment_frequencies
    add
        constraint dict_ins_paypayment_frequencies_fk_root 
        foreign key( root_id) references fos.dict_ins_payment_frequencies( id);

alter table fos.dict_ins_payment_frequencies
    add
        constraint dict_ins_payment_frequencies_fk_prior_version 
        foreign key( prior_version_id) references fos.dict_ins_payment_frequencies( id);

alter table fos.dict_ins_payment_frequencies
    add
        constraint dict_ins_payment_frequencies_fk_next_version
        foreign key( next_version_id) references fos.dict_ins_payment_frequencies( id);

grant select on fos.dict_ins_payment_frequencies to public;
grant select on fos.dict_ins_payment_frequencies to fos_public;

comment on table fos.dict_ins_payment_frequencies is 'Страхование, справочник частот оплаты (нам)';

comment on column fos.dict_ins_payment_frequencies.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_payment_frequencies.branch_id is 'Ссылка на филиал';
comment on column fos.dict_ins_payment_frequencies.root_id is 'Ссылка на корневую версию';
comment on column fos.dict_ins_payment_frequencies.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.dict_ins_payment_frequencies.next_version_id is 'Ссылка на следующую версию';
comment on column fos.dict_ins_payment_frequencies.code is 'Код';
comment on column fos.dict_ins_payment_frequencies.name is 'Наименование';
comment on column fos.dict_ins_payment_frequencies.frequency is 'Частота';
comment on column fos.dict_ins_payment_frequencies.month_period is 'Периодичность в месяцах';
comment on column fos.dict_ins_payment_frequencies.description is 'Описание';
comment on column fos.dict_ins_payment_frequencies.comments is 'Коменты';
comment on column fos.dict_ins_payment_frequencies.cu is 'Крайний изменивший';
comment on column fos.dict_ins_payment_frequencies.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_payment_frequencies.ct is 'Терминал';
comment on column fos.dict_ins_payment_frequencies.cu_id is 'Пользователь';


/*  
-- Проверка
select
    *
from
    dbo.dict_ins_payment_frequencies with (nolock)
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
