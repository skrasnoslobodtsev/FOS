--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 02.06.2016
    Purpose   : Таблица договоров

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
*/
--if OBJECT_ID( 'dbo.[contracts]', 'U') is NOT NULL
--    drop table dbo.[contracts];
--go
drop table fos.contracts cascade;
/*
  Атрибуты:
    id                  - Уникальный идентификатор экземпляра
    -- Ссылки
    version_id          - Ссылка на предыдущую версию
    kind_id             - Ссылка на вид договора, простой справочник
    status_id           - Статус договора

    -- Атрибуты
    begin_date          - Дата начала действия договора
    end_date            - Дата окончания действия договора
    accept_date         - Дата акцепта договора
    cancel_date         - Дата расторжения
    restore_date        - Дата восстановления


    -- Не обязательные, но тоже есть у всех
    description       - Описание
    comments          - Коменты
    -- Системные
    change_user       - Пользователь
    chnage_date       - Дата последнего изменения
    change_term       - Терминал
    change_user_id    - Ссылка на юзверя
*/
create table fos.contracts
(
    id                  bigint          NOT NULL,
    -- Ссылки
    version_id          bigint          NULL,
    kind_id             bigint          NOT NULL,
    state_id            bigint          NULL,

    -- Атрибуты
    sign_date           timestamp       NULL,
    from_date           timestamp       NULL,
    till_date           timestamp       NULL,
    accept_date         timestamp       NULL,
    cancel_date         timestamp       NULL,
    restore_date        timestamp       NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    change_user         varchar(256)    NOT NULL default session_user,
    change_date         timestamp       NOT NULL default current_timestamp,
    change_term         varchar(256)    NOT NULL default inet_client_addr(),
    change_user_id      bigint          NULL,
    -- constraints ---------------------------------------------
    constraint contracts_pk primary key( id),
    -- Ссылки
    constraint contracts_fk_version foreign key( version_id) references fos.contracts( id),
    constraint contracts_fk_document foreign key( id) references fos.documents( id),
    constraint contracts_fk_kind foreign key( kind_id) references fos.dict_enum_items( id),
    constraint contracts_fk_state foreign key( state_id) references fos.dict_enum_items( id),
    constraint constract_fk_cu_id foreign key( change_user_id) references fos.sys_users( id)
)
;

grant select on fos.contracts to public;
grant select on fos.contracts to fos_public;

comment on table fos.contracts is 'Договора';

comment on column fos.contracts.id is 'Уникальный идентификатор экземпляра';
comment on column fos.contracts.version_id is 'Ссылка на предыдущую версию';
comment on column fos.contracts.kind_id is 'Ссылка на вид договора, справочник fos.dict_enum_items';
comment on column fos.contracts.state_id is 'Ссылка на статус договора, справочник fos.dict_enum_items';
comment on column fos.contracts.sign_date is 'Дата подписания';
comment on column fos.contracts.from_date is 'Дата начала действия';
comment on column fos.contracts.till_date is 'Дата окончания действия';
comment on column fos.contracts.accept_date is 'Дата акцепта';
comment on column fos.contracts.cancel_date is 'Дата расторжения';
comment on column fos.contracts.restore_date is 'Дата восстановления';
comment on column fos.contracts.description is 'Описание';
comment on column fos.contracts.comments is 'Коменты';
comment on column fos.contracts.change_user is 'Крайний изменивший';
comment on column fos.contracts.change_date is 'Крайняя дата изменений';
comment on column fos.contracts.change_term is 'Терминал';
comment on column fos.contracts.change_user_id is 'Пользователь';

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
from 
    dbo.vDictionaries
order by 
    1, 
    4
*/
