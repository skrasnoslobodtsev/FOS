--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 09.11.2016
    Purpose   : Объекты учёта, агентские договора

Change list:
10.03.2017 Перепечко А.В. Перетаскиваем в зону страхования
16.08.2017 Перепечко А.В. Добиваем атрибуты
*/
--if OBJECT_ID( 'dbo.ins_agent_contracts', 'U') is NOT NULL
--    drop table dbo.ins_agent_contracts;
--go
drop table fos.ins_agent_contracts cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_agent_id        - Ссылка на страхового агента

        -- Атрибуты
        -- ..

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.ins_agent_contracts
(
    id                      bigint          NOT NULL,
    -- Ссылки
    ins_agent_id            bigint          NOT NULL,

    -- Атрибуты
    -- ..

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------
    constraint ins_agent_contracts_pk primary key ( id),
    -- Ссылки
    constraint ins_agent_contracts_fk_contract foreign key( id) references fos.contracts( id),
    constraint ins_agent_contracts_fk_ins_agent foreign key( ins_agent_id) references fos.dict_ins_agents( id),
    constraint ins_agent_contracts_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
);

grant select on fos.ins_agent_contracts to public;
grant select on fos.ins_agent_contracts to fos_public;

comment on table fos.ins_agent_contracts is 'Объекты учёта, агентские договора';

comment on column fos.ins_agent_contracts.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_agent_contracts.ins_agent_id is 'Ссылка на агента';
comment on column fos.ins_agent_contracts.description is 'Описание';
comment on column fos.ins_agent_contracts.comments is 'Коменты';
comment on column fos.ins_agent_contracts.cu is 'Крайний изменивший';
comment on column fos.ins_agent_contracts.cd is 'Крайняя дата изменений';
comment on column fos.ins_agent_contracts.ct is 'Терминал';
comment on column fos.ins_agent_contracts.cu_id is 'Пользователь';

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
    dbo.SysSettings with (NoLock)

select
  *
from dbo.vDictionaries
order by 1, 4
*/
