--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 12.08.2017
    Purpose   : Страхование, справочник частот оплаты (нам)

Change list:
12.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_payment_frequencies', 'U') is NOT NULL
--    drop table dbo.dict_ins_payment_frequencies;
--go
drop table fos.dict_ins_payment_frequencies cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        branch_id           - Ссылка на филиал

        -- Атрибуты
        code                - Код
        name                - Наименование
        frequency           - Частота оплат за год
        month_period        - Периодичность в месяцах

        -- Не обязательные, но тоже есть у всех
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

    -- Атрибуты
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    frequency           int             NOT NULL,
    month_period        int             NOT NULL,

    -- description and comments    
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
    constraint dict_ins_payment_frequencies_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
    -- Проверки
);

grant select on fos.dict_ins_payment_frequencies to public;
grant select on fos.dict_ins_payment_frequencies to fos_public;

comment on table fos.dict_ins_payment_frequencies is 'Страхование, справочник частот оплаты (нам)';

comment on column fos.dict_ins_payment_frequencies.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_payment_frequencies.branch_id is 'Ссылка на филиал';
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
