/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 17.01.2017
    Purpose   : Страхование, справочник котировок индексов

Change list:
*/
drop table if exists fos.dict_ins_option_index_quotes cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_option_index_id     - Ссылка на индекс опциона ( fos.dict_ins_option_indexes)

        -- Атрибуты
        quote_date              - Дата котировки
        quote_value             - Значение индекса

        -- Признаки

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты

        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.dict_ins_option_index_quotes
(
    id                      bigint          NOT NULL,
    -- Ссылки
    ins_option_index_id     bigint          not null,

    -- Атрибуты
    quote_date              timestamp       not null,
    quote_value             float           not null,

    -- Признаки

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,

    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_ins_option_index_quotes_pk primary key ( id),
    -- Ссылки
    constraint dict_ins_option_index_quotes_fk_ins_option_index foreign key( ins_option_index_id) references fos.dict_ins_option_indexes( id),
    constraint dict_ins_option_index_quotes_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint dict_ins_option_index_quotes_uk unique( ins_option_index_id, quote_date)
);

grant select on fos.dict_ins_option_index_quotes to public;
grant select on fos.dict_ins_option_index_quotes to fos_public;

comment on table fos.dict_ins_option_index_quotes is 'Страхование, справочник стратегий опционов';

comment on column fos.dict_ins_option_index_quotes.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_option_index_quotes.ins_option_index_id is 'Ссылка на индекс опциона ( fos.dict_ins_option_indexes)';
comment on column fos.dict_ins_option_index_quotes.quote_date is 'Дата котировки';
comment on column fos.dict_ins_option_index_quotes.quote_value is 'Значение котировки';
comment on column fos.dict_ins_option_index_quotes.description is 'Описание';
comment on column fos.dict_ins_option_index_quotes.comments is 'Коменты';
comment on column fos.dict_ins_option_index_quotes.cu is 'Крайний изменивший';
comment on column fos.dict_ins_option_index_quotes.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_option_index_quotes.ct is 'Терминал';
comment on column fos.dict_ins_option_index_quotes.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.dict_ins_option_index_quotes
;

-- SQL запросы 
select
    error_code,
    error_message
from 
    fos.sys_errors
order by 
    error_code desc
;

select
  *
from 
    fos.sys_settings
;
*/
