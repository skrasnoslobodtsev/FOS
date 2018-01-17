/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 17.01.2018
    Purpose   : Объекты учёта, опционы

Change list:
*/
drop table if exists fos.ins_options cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        root_id                 - Ссылка на первую версию
        prior_version_id        - Ссылка на предыдущую версию
        next_version_id         - Ссылка на след.версию

        option_kind_id          - Ссылка на вид опциона (американский, европейский и т.д., справочник fos.dict_enum_items)
        currency_id             - Валюта покупки опциона

        -- Атрибуты
        buy_date                - Дата покупки
        expiration_date         - Дата истечения
        exercise_date           - Дата исполнения
        redemption_date         - Дата погашения
        price_percent           - Цена процент
        sales_start_date        - Дата старта продаж
        sales_stop_date         - Дата окончания продаж
        def_participation_factor    - Коэффициент участия по умолчанию
        part_in_gf              - ГФ
        profitability_gf        - Доходность ГФ

        `-- Признаки
        active_flag             - Признак активности: 0 - нет, 1 (default) - да

        -- Не обязательные, но тоже есть у всех
        delete_flag             - Признак удаления: 0 (default) - нет, 1 - да
        description             - Описание
        comments                - Коменты
        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.ins_options
(
    id                      bigint          NOT NULL,
    -- Ссылки
    root_id                 bigint          NULL,
    prior_version_id        bigint          NULL,
    next_version_id         bigint          NULL,

    option_kind_id          bigint          not null,
    currency_id             bigint          not null,

    -- Атрибуты
    code                    varchar(50)     null,
    name                    varchar(100)    null,

    buy_date                timestamp       null,
    expiration_date         timestamp       null,
    exercise_date           timestamp       null,
    redemption_date         timestamp       null,
    price_percent           float           null,
    sales_start_date        timestamp       null,
    sales_stop_date         timestamp       null,
    def_participation_factor    float       null,
    part_in_gf              float           null,
    profitability_gf        float           null,

    -- Признаки
    active_flag             int             not null default 1,

    -- description and comments    
    delete_flag             int             not null default 0,
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------
    constraint ins_options_pk primary key ( id),
    -- Ссылки
    constraint ins_options_fk_option_kind foreign key( option_kind_id) references fos.dict_enum_items( id),
    constraint ins_options_fk_currency foreign key( currency_id) references fos.dict_currencies( id),
    -- Ссылки на версии
    constraint ins_options_fk_root foreign key( root_id) references fos.ins_options( id),
    constraint ins_options_fk_prior_version foreign key( prior_version_id) references fos.ins_options( id),
    constraint ins_options_fk_next_version foreign key( next_version_id) references fos.ins_options( id),
    -- Ограничения проверки
    constraint ins_options_ch_af check( active_flag in ( 0, 1)),
    constraint ins_options_ch_df check( delete_flag in ( 0, 1))
);

grant select on fos.ins_options to public;
grant select on fos.ins_options to fos_public;

comment on table fos.ins_options is 'Объекты учёта, опционы';

comment on column fos.ins_options.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_options.root_id is 'Ссылка на корневую версию';
comment on column fos.ins_options.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.ins_options.next_version_id is 'Ссылка на следующую версию';
comment on column fos.ins_options.option_kind_id is 'Ссылка на вид опциона (американский, европейский и т.д., справочник fos.dict_enum_items)';
comment on column fos.ins_options.currency_id is 'Валюта покупки опциона';
comment on column fos.ins_options.code is 'Код';
comment on column fos.ins_options.name is 'Наименование';
comment on column fos.ins_options.buy_date is 'Дата покупки';
comment on column fos.ins_options.expiration_date is 'Дата истечения';
comment on column fos.ins_options.exercise_date is 'Дата исполнения';
comment on column fos.ins_options.redemption_date is 'Дата погашения';
comment on column fos.ins_options.price_percent is 'Процент от цены';
comment on column fos.ins_options.sales_start_date is 'Дата старта продаж договоров страхования';
comment on column fos.ins_options.sales_stop_date is 'Дата окончания продаж договоров страхования';
comment on column fos.ins_options.def_participation_factor is 'Коэффициент участия по умолчанию';
comment on column fos.ins_options.part_in_gf is 'ГФ';
comment on column fos.ins_options.profitability_gf is 'Доходность ГФ';
comment on column fos.ins_options.active_flag is 'Признак активности: 0 - нет, 1 (default) - да';
comment on column fos.ins_options.delete_flag is 'Признак удаления: 0 (default) - нет, 1 - да';
comment on column fos.ins_options.description is 'Описание';
comment on column fos.ins_options.comments is 'Коменты';
comment on column fos.ins_options.cu is 'Крайний изменивший';
comment on column fos.ins_options.cd is 'Крайняя дата изменений';
comment on column fos.ins_options.ct is 'Терминал';
comment on column fos.ins_options.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.ins_contracts with (nolock)
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
    dbo.SysSettings with (NoLock)

select
  *
from dbo.vDictionaries
order by 1, 4
*/
