﻿--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 02.06.2016
    Purpose   : Документы, базовая таблица

Change list:
08.11.2016 Перепечко А.В. Убираем серию
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
10.03.2017 Перепечко А.В. Дорабатываем базовый набор атрибутов
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
*/
--if OBJECT_ID( 'dbo.[documents]', 'U') is NOT NULL
--    drop table dbo.[documents];
--go
drop table fos.documents cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        branch_id           - Ссылка на филиал
        owner_id            - Ссылка на документ владелец
        type_id             - Тип документа, справочник dbo.dict_enum_items

        -- Атрибуты
        doc_number          - Номер документа

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        change_user         - Пользователь
        chnage_date         - Дата последнего изменения
        change_term         - Терминал
        change_user_id      - Ссылка на юзверя
*/
create table fos.documents
(
    id                  bigint          NOT NULL,
    -- Ссылки
    branch_id           bigint          NULL,
    owner_id            bigint          NULL,
    type_id             bigint          NOT NULL,

    -- Атрибуты
    doc_number          varchar(100)    NOT NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- constraints ---------------------------------------------

    -- system info
    create_user         varchar(256)    NOT NULL default session_user,
    create_date         timestamp       NOT NULL default current_timestamp,
    create_term         varchar(256)    NOT NULL default inet_client_addr(),
    create_user_id      bigint          NULL,
    change_user         varchar(256)    NOT NULL default session_user,
    change_date         timestamp       NOT NULL default current_timestamp,
    change_term         varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id      bigint          NULL,
    -- Ограничения
    constraint documents_pk primary key ( id),
    -- Ссылки
    constraint documents_fk_owners foreign key ( owner_id) references fos.documents( id),
    constraint documents_fk_branches foreign key ( branch_id) references fos.branches( id),
    constraint documents_fk_types foreign key( type_id) references fos.dict_enum_items( id),
    constraint documents_fk_cru_id foreign key( create_user_id) references fos.sys_users( id),
    constraint documents_fk_chu_id foreign key( change_user_id) references fos.sys_users( id)
)
;

create index documents_idx_item_owner on fos.documents( id, owner_id);
create index documents_idx_type_number on fos.documents( type_id, doc_number);
create index documents_idx_branch_type_num on fos.documents( branch_id, type_id, doc_number);

grant select on fos.documents to public;
grant select on fos.documents to fos_public;

/*  
-- Проверка
select
    *
from
    dbo.document with (nolock)
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
