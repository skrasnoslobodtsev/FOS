--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 16.08.2017
    Purpose   : Объекты учёта, привязка агента к договору страхования
*/
--if OBJECT_ID( 'dbo.ins_agents', 'U') is NOT NULL
--    drop table dbo.ins_agents;
--go
drop table fos.ins_agents cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_contract_id     - Ссылка на договор страхования
        ins_agent_id        - Ссылка на агента

        -- Атрибуты

        -- Не обязательные, но тоже есть у всех

        description         - Описание
        comments            - Коменты

        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.ins_agents
(
    id                      bigint          NOT NULL,
    -- Ссылки
    ins_contract_id         bigint          NOT NULL,
    ins_agent_id            bigint          NOT NULL,

    -- Атрибуты

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,

    -- constraints ---------------------------------------------
    constraint ins_agents_pk primary key ( id),
    -- Ссылки
    constraint ins_agents_fk_ins_contract foreign key( ins_contract_id) references fos.ins_contracts( id),
    constraint ins_agents_fk_ins_agent foreign key( ins_agent_id) references fos.dict_ins_agents( id),
    constraint ins_agents_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
    -- Уникальность
    -- Проверки
);

grant select on fos.ins_agents to public;
grant select on fos.ins_agents to fos_public;

comment on table fos.ins_agents is 'Объекты учёта, привязка агента к договору страхования';

comment on column fos.ins_agents.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_agents.ins_contract_id is 'Ссылка на договор страхования';
comment on column fos.ins_agents.ins_agent_id is 'Ссылка на агента';
comment on column fos.ins_agents.description is 'Описание';
comment on column fos.ins_agents.comments is 'Коменты';
comment on column fos.ins_agents.cu is 'Крайний изменивший';
comment on column fos.ins_agents.cd is 'Крайняя дата изменений';
comment on column fos.ins_agents.ct is 'Терминал';
comment on column fos.ins_agents.cu_id is 'Пользователь';
/*  
-- Проверка
select
    *
from
    dbo.dict_ins_agents with (nolock)
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
