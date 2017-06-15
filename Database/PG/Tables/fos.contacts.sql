--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 29.06.2016
    Purpose   : Контакты

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
*/
--if OBJECT_ID( 'dbo.[contacts]', 'U') is NOT NULL
--    drop table dbo.[contacts];
drop table fos.contacts cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        kind_id             - Ссылка на вид контакта, справочник dicts_contact_kinds
        contragent_id       - Ссылка на контрагента

        -- Атрибуты
        name                - Дополнительное значение контакта, например контактное лицо
        data                - Данные по контакту, например номер телефоны или e-mail

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        change_user         - Пользователь
        chnage_date         - Дата последнего изменения
        change_term         - Терминал
        change_user_id      - Ссылка на юзверя
*/
create table fos.contacts
(
    id                  bigint          NOT NULL,
    -- Ссылки
    kind_id             bigint          NOT NULL,
    contragent_id       bigint          NOT NULL,
    -- Атрибуты
    name                varchar(100)    NULL,
    data                varchar(2000)   NULL,

    -- description and comments    
    description     varchar(500)        NULL,
    comments        varchar(1000)       NULL,
    -- system info
    change_user     varchar(256)        NOT NULL default session_user,
    change_date     timestamp           NOT NULL default current_timestamp,
    change_term     varchar(256)        NOT NULL default inet_client_addr(),
    change_user_id  bigint              NULL,
    -- constraints ---------------------------------------------
    constraint contacts_pk  primary key( id),
    constraint contacts_fk_contragent  foreign key( contragent_id) references fos.contragents( id),
    constraint contacts_fk_kind foreign key( kind_id) references fos.dict_enum_items( id),
    constraint contacts_fk_cu_id foreign key( change_user_id) references fos.sys_users( id)
)
;

grant select on fos.contacts to public;
grant select on fos.contacts to fos_public;

comment on table fos.contacts is 'Контакты контрагентов';

comment on column fos.contacts.id is 'Уникальный идентификатор экземпляра';
comment on column fos.contacts.kind_id is 'Вид контакта, ссылка на справочник fos.dict_enum_items';
comment on column fos.contacts.contragent_id is 'Ссылка на контрагента';
comment on column fos.contacts.name is 'Наименование';
comment on column fos.contacts.data is 'Значение';
comment on column fos.contacts.description is 'Описание';
comment on column fos.contacts.comments is 'Коменты';
comment on column fos.contacts.change_user is 'Крайний изменивший';
comment on column fos.contacts.change_date is 'Крайняя дата изменений';
comment on column fos.contacts.change_term is 'Терминал';
comment on column fos.contacts.change_user_id is 'Пользователь';

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

