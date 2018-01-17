/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 17.01.2018
    Purpose   : Объекты учёта, базовые индексы опциона

Change list:
*/
drop table if exists fos.ins_option_base_indexes cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_option_id           - Ссылка на опцион
        ins_option_index_id     - Ссылка на индекс
        ins_option_index_quote_id   - Ссылка на котировку индекса на дату покупки опциона

        -- Атрибуты
        short_name              - Краткое наименование
        name                    - Наименование

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
create table fos.ins_option_base_indexes
(
    id                      bigint          NOT NULL,
    -- Ссылки
    ins_option_id           bigint          not null,
    ins_option_index_id     bigint          not null,
    ins_option_index_quote_id   bigint      not null,

    -- Атрибуты
    short_name              varchar(50)     null,
    name                    varchar(100)    null,

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

    constraint ins_option_base_indexes_pk primary key ( id),
    -- Ссылки
    constraint ins_option_base_indexes_fk_ins_option foreign key( ins_option_id) references fos.ins_options( id),
    constraint ins_option_base_indexes_fk_ins_option_index foreign key( ins_option_index_id) references fos.dict_ins_option_indexes( id),
    constraint ins_option_base_indexes_fk_ins_option_index_quote foreign key( ins_option_index_quote_id) references fos.dict_ins_option_index_quotes( id),
    constraint ins_option_base_indexes_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Ссылки на версии
    -- Уникальность
    constraint ins_option_base_indexes_uk unique( ins_option_id, ins_option_index_id)
    -- Проверки
);

grant select on fos.ins_option_base_indexes to public;
grant select on fos.ins_option_base_indexes to fos_public;

comment on table fos.ins_option_base_indexes is 'Объекты учёта, базовые индексы опциона';

comment on column fos.ins_option_base_indexes.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_option_base_indexes.ins_option_id is 'Ссылка на опцион';
comment on column fos.ins_option_base_indexes.ins_option_index_id is 'Ссылка на индекс';
comment on column fos.ins_option_base_indexes.ins_option_index_quote_id is 'Ссылка на котировку индекса на дату покупки опциона';
comment on column fos.ins_option_base_indexes.short_name is 'Краткое наименование';
comment on column fos.ins_option_base_indexes.name is 'Наименование';
comment on column fos.ins_option_base_indexes.description is 'Описание';
comment on column fos.ins_option_base_indexes.comments is 'Коменты';
comment on column fos.ins_option_base_indexes.cu is 'Крайний изменивший';
comment on column fos.ins_option_base_indexes.cd is 'Крайняя дата изменений';
comment on column fos.ins_option_base_indexes.ct is 'Терминал';
comment on column fos.ins_option_base_indexes.cu_id is 'Пользователь';
/*
-- Проверка
select
    *
from
    fos.ins_option_base_indexes
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

