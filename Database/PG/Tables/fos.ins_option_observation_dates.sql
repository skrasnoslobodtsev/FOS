/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 17.01.2018
    Purpose   : Объекты учёта, даты наблюдения

Change list:
*/
drop table if exists fos.ins_option_observation_dates cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_option_id           - Ссылка на опцион

        -- Атрибуты
        observation_date        - Дата наблюдения

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
create table fos.ins_option_observation_dates
(
    id                      bigint          NOT NULL,
    -- Ссылки
    ins_option_id           bigint          not null,

    -- Атрибуты
    observation_date        timestamp       not null,

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

    constraint ins_option_observation_dates_pk primary key ( id),
    -- Ссылки
    constraint ins_option_observation_dates_fk_ins_option foreign key( ins_option_id) references fos.ins_options( id),
    -- Ссылки на версии
    -- Уникальность
    constraint ins_option_observation_dates_uk unique( ins_option_id, observation_date)
    -- Проверки
);

grant select on fos.ins_option_observation_dates to public;
grant select on fos.ins_option_observation_dates to fos_public;

comment on table fos.ins_option_observation_dates is 'Объекты учёта, даты наблюдения';

comment on column fos.ins_option_observation_dates.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_option_observation_dates.ins_option_id is 'Ссылка на опцион';
comment on column fos.ins_option_observation_dates.observation_date is 'Дата наблюдения';
comment on column fos.ins_option_observation_dates.description is 'Описание';
comment on column fos.ins_option_observation_dates.comments is 'Коменты';
comment on column fos.ins_option_observation_dates.cu is 'Крайний изменивший';
comment on column fos.ins_option_observation_dates.cd is 'Крайняя дата изменений';
comment on column fos.ins_option_observation_dates.ct is 'Терминал';
comment on column fos.ins_option_observation_dates.cu_id is 'Пользователь';
/*
-- Проверка
select
    *
from
    fos.ins_option_observation_dates
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

