--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 09.11.2016
    Purpose   : Страхование, справочник агентов/агентские профили

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
10.03.2017 Перепечко А.В. Переносим в зону страхования
16.08.2017 Перепечко А.В. Переименовываем таблицу, добиваем атрибуты
16.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_agents', 'U') is NOT NULL
--    drop table dbo.dict_ins_agents;
--go
drop table fos.dict_ins_agents cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        contragent_id       - Ссылка на контрагента
        branch_id           - Ссылка на филиал
        state_id            - Ссылка на статус агента (простые справочники, статус агента)

        -- Атрибуты
        code                - Уникальный код агента
        name                - Наименование агента

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.dict_ins_agents
(
    id                      bigint          NOT NULL,
    -- Ссылки
    contragent_id           bigint          NOT NULL,
    branch_id               bigint          NULL,
    state_id                bigint          NOT NULL,

    -- Атрибуты
    code                    varchar(50)     NOT NULL,
    name                    varchar(100)    NOT NULL,

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_ins_agents_pk primary key ( id),
    -- Ссылки
    constraint dict_ins_agents_fk_contragent foreign key( contragent_id) references fos.contragents( id),
    constraint dict_ins_agents_fk_branch foreign key( branch_id) references fos.branches( id),
    constraint dict_ins_agents_fk_state foreign key( state_id) references fos.dict_enum_items( id),
    constraint dict_ins_agents_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint dict_ins_agents_uk_code unique( branch_id, code),
    -- Проверки
    constraint dict_ins_agents_ch_code check( code != '')
);

grant select on fos.dict_ins_agents to public;
grant select on fos.dict_ins_agents to fos_public;

comment on table fos.dict_ins_agents is 'Страхование, справочник агентов/агентские профили';

comment on column fos.dict_ins_agents.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_agents.contragent_id is 'Ссылка на контрагента';
comment on column fos.dict_ins_agents.branch_id is 'Ссылка на филиал';
comment on column fos.dict_ins_agents.state_id is 'Ссылка на статус, fos.dict_enum_items';
comment on column fos.dict_ins_agents.code is 'Уникальный код агента';
comment on column fos.dict_ins_agents.name is 'Наименование';
comment on column fos.dict_ins_agents.description is 'Описание';
comment on column fos.dict_ins_agents.comments is 'Коменты';
comment on column fos.dict_ins_agents.cu is 'Крайний изменивший';
comment on column fos.dict_ins_agents.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_agents.ct is 'Терминал';
comment on column fos.dict_ins_agents.cu_id is 'Пользователь';

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
