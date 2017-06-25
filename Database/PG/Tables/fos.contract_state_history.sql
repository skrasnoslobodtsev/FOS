--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 10.03.2017
    Purpose   : История изменения статусов договора

Change list:
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.contract_state_history', 'U') is NOT NULL
--    drop table dbo.contract_state_history;
drop table fos.contract_state_history cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        contract_id         - Ссыка на договор
        state_id            - Ссылка на статус

        -- Атрибуты
        reason              - Причина
        action_date         - Дата действия

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.contract_state_history
(
    id                  bigint          NOT NULL,
    -- Ссылки
    contract_id         bigint          NOT NULL,
    state_id            bigint          NOT NULL,

    -- Атрибуты
    reason              varchar(4000)   NOT NULL,
    action_date         timestamp       NOT NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint contract_state_history_pk primary key( id),
    -- Ссылки
    constraint contract_state_history_fk_contract foreign key( contract_id) references fos.contracts( id),
    constraint contract_state_history_fk_state foreign key( state_id) references fos.dict_enum_items( id),
    constraint contract_state_history_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
)
;

grant select on fos.contract_state_history to public;
grant select on fos.contract_state_history to fos_public;

comment on table fos.contract_state_history is 'История изменения статуса договора';

comment on column fos.contract_state_history.id is 'Уникальный идентификатор экземпляра';
comment on column fos.contract_state_history.contract_id is 'Ссылка на договора, fos.contracts';
comment on column fos.contract_state_history.state_id is 'Ссылка на статус договора, справочник fos.dict_enum_items';
comment on column fos.contract_state_history.reason is 'Причина';
comment on column fos.contract_state_history.action_date is 'Дата действия';
comment on column fos.contract_state_history.description is 'Описание';
comment on column fos.contract_state_history.comments is 'Коментарий';
comment on column fos.contract_state_history.cu is 'Крайний изменивший';
comment on column fos.contract_state_history.cd is 'Крайняя дата изменений';
comment on column fos.contract_state_history.ct is 'Терминал';
comment on column fos.contract_state_history.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.[table_name]
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
