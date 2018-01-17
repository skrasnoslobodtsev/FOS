--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 02.06.2016
    Purpose   : Объекты учёта, таблица договоров

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
12.08.2017 Перепечко А.В. Дорабатываем версионность (root, prior, next)
*/
--if OBJECT_ID( 'dbo.[contracts]', 'U') is NOT NULL
--    drop table dbo.[contracts];
--go
drop table if exists fos.contracts cascade;
/*
  Атрибуты:
    id                  - Уникальный идентификатор экземпляра
    -- Ссылки
    root_id             - Ссылка на корневую версию
    prior_version_id    - Ссылка на предыдущую версию
    next_version_id     - Ссылка на следующую версию
    kind_id             - Ссылка на вид договора, простой справочник
    status_id           - Статус договора

    -- Атрибуты
    from_date           - Дата начала действия договора
    till_date           - Дата окончания действия договора
    accept_date         - Дата акцепта договора
    cancel_date         - Дата расторжения
    restore_date        - Дата восстановления

    -- Не обязательные, но тоже есть у всех
    description         - Описание
    comments            - Коменты
    -- Системные
    cu                  - Пользователь
    cd                  - Дата последнего изменения
    ct                  - Терминал
    cu_id               - Ссылка на юзверя
*/
create table fos.contracts
(
    id                  bigint          NOT NULL,
    -- Ссылки
    root_id             bigint          NOT NULL,
    prior_version_id    bigint          NULL,
    next_version_id     bigint          NULL,
    kind_id             bigint          NOT NULL,
    status_id           bigint          NULL,

    -- Атрибуты
    sign_date           timestamp       NULL,
    from_date           timestamp       NULL,
    till_date           timestamp       NULL,
    accept_date         timestamp       NULL,
    cancel_date         timestamp       NULL,
    restore_date        timestamp       NULL,

    -- description and comments
    delete_flag         int             not null default 0,
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint contracts_pk primary key( id),
    -- Ссылки
    constraint contracts_fk_document foreign key( id) references fos.documents( id),
    constraint contracts_fk_root foreign key( root_id) references fos.contracts( id),
    constraint contracts_fk_prior_version foreign key( prior_version_id) references fos.contracts( id),
    constraint contracts_fk_next_version foreign key( next_version_id) references fos.contracts( id),
    constraint contracts_fk_kind foreign key( kind_id) references fos.dict_enum_items( id),
    constraint contracts_fk_status foreign key( status_id) references fos.dict_enum_items( id),
    constraint contracts_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    constraint contracts_ch_df check( delete_flag in ( 0, 1))
)
;

grant select on fos.contracts to public;
grant select on fos.contracts to fos_public;

comment on table fos.contracts is 'Объекты учёта, таблица договоров';

comment on column fos.contracts.id is 'Уникальный идентификатор экземпляра';
comment on column fos.contracts.root_id is 'Ссылка на корневую версию';
comment on column fos.contracts.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.contracts.next_version_id is 'Ссылка на следующую версию';
comment on column fos.contracts.kind_id is 'Ссылка на вид договора, справочник fos.dict_enum_items';
comment on column fos.contracts.status_id is 'Ссылка на статус договора, справочник fos.dict_enum_items';
comment on column fos.contracts.sign_date is 'Дата подписания';
comment on column fos.contracts.from_date is 'Дата начала действия';
comment on column fos.contracts.till_date is 'Дата окончания действия';
comment on column fos.contracts.accept_date is 'Дата акцепта';
comment on column fos.contracts.cancel_date is 'Дата расторжения';
comment on column fos.contracts.restore_date is 'Дата восстановления';
comment on column fos.contracts.delete_flag is 'Признак удаления: 0 (default) - нет, 1 - да';
comment on column fos.contracts.description is 'Описание';
comment on column fos.contracts.comments is 'Коменты';
comment on column fos.contracts.cu is 'Крайний изменивший';
comment on column fos.contracts.cd is 'Крайняя дата изменений';
comment on column fos.contracts.ct is 'Терминал';
comment on column fos.contracts.cu_id is 'Пользователь';

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
