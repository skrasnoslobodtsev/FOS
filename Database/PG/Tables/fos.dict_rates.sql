--use template_db
--go
/*
  Developer : Перепечко А.В.
  Created   : 27.03.2015
  Purpose   : Справочник курсов

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
05.05.2017 Перепечко А.В. Переносим на PG
*/
/* Удаляем, если есть */
--if OBJECT_ID( 'dbo.dict_rates', 'U') is NOT NULL
--    drop table dbo.dict_rates;
drop table fos.dict_rates cascade;
/*
    Атрибуты:
        id              - Уникальный идентификатор экземпляра
        source_id       - Ссылка на источник курса (справочник dict_items)
        branch_id       - Ссылка на филиал
        base_currency_id - Ссылка на базовую валюту
        currency_id     - Ссылка на валюту к которой курс
        rate            - Курс
        multiplier      - Множитель (т.е. к какому кол-ву валюты)
        rate_date       - Дата курса
        description     - Описание
        comments        - Коментарии
        change_user     - Последний изменивший
        change_date     - Последняя дата изменений
        change_term     - Терминал
        change_user_id  - Ссылка на пользователя
*/
create table fos.dict_rates
(
    id                  int             NOT NULL,
    -- fk here
    source_id           int             NOT NULL,
    branch_id           int             NULL,
    base_currency_id    int             NULL,
    currency_id         int             NOT NULL,
    
    -- attributes
    rate                float           NOT NULL default 1.0,
    multiplier          float           NOT NULL default 1.0,
    rate_date           timestamp       NOT NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    change_user         varchar(256)    NOT NULL default session_user,
    change_date         timestamp       NOT NULL default current_timestamp,
    change_term         varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id      int             NULL,
    -- constraints ---------------------------------------------
    constraint dict_rates_pk primary key (id),
    constraint dict_rates_fk_source foreign key ( source_id) references fos.dict_enum_items( id),
    constraint dict_rates_fk_branch foreign key( branch_id) references fos.branches( id),
    constraint dict_rates_fk_user_id foreign key( change_user_id) references fos.sys_users( id),
    constraint dict_rates_fk_base_currency foreign key( base_currency_id) references fos.dict_currencies( id),
    constraint dict_rates_fk_currency foreign key( currency_id) references fos.dict_currencies( id),
    constraint dict_rates_uk unique( source_id, branch_id, base_currency_id, currency_id, rate_date)
)
;

grant select on fos.dict_rates to public;
grant select on fos.dict_rates to fos_public;

comment on table fos.dict_rates is 'Курсы валют';

comment on column fos.dict_rates.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_rates.source_id is 'Ссылка на источник курсов (dict_enum_items';
comment on column fos.dict_rates.branch_id is 'Ссылка на филиал';
comment on column fos.dict_rates.base_currency_id is 'Ссылка на базовую валюту';
comment on column fos.dict_rates.currency_id is 'Ссылка на валюту к которой курс';
comment on column fos.dict_rates.rate is 'Курс';
comment on column fos.dict_rates.multiplier is 'Множитель';
comment on column fos.dict_rates.rate_date is 'Дата курса';
comment on column fos.dict_rates.description is 'Описание';
comment on column fos.dict_rates.comments is 'Коменты';
comment on column fos.dict_rates.change_user is 'Карйиний изменивший';
comment on column fos.dict_rates.change_date is 'Крайняя дата изменения';
comment on column fos.dict_rates.change_term is 'Терминал';
comment on column fos.dict_rates.change_user_id is 'Пользователь';

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