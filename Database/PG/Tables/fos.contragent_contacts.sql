--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 29.06.2016
    Purpose   : Контакты контрагента

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Переименовываем с fos.contacts на fos.contragent_contacts
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.[contacts]', 'U') is NOT NULL
--    drop table dbo.[contacts];
drop table if exists fos.contragent_contacts cascade;
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
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.contragent_contacts
(
    id                  bigint          NOT NULL,
    -- Ссылки
    kind_id             bigint          NOT NULL,
    contragent_id       bigint          NOT NULL,
    -- Атрибуты
    name                varchar(100)    NULL,
    data                varchar(2000)   NULL,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint contragent_contacts_pk  primary key( id),
    constraint contragent_contacts_fk_contragent  foreign key( contragent_id) references fos.contragents( id),
    constraint contragent_contacts_fk_kind foreign key( kind_id) references fos.dict_enum_items( id),
    constraint contragent_contacts_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
)
;

grant select on fos.contragent_contacts to public;
grant select on fos.contragent_contacts to fos_public;

comment on table fos.contragent_contacts is 'Контакты контрагентов';

comment on column fos.contragent_contacts.id is 'Уникальный идентификатор экземпляра';
comment on column fos.contragent_contacts.kind_id is 'Вид контакта, ссылка на справочник fos.dict_enum_items';
comment on column fos.contragent_contacts.contragent_id is 'Ссылка на контрагента';
comment on column fos.contragent_contacts.name is 'Наименование';
comment on column fos.contragent_contacts.data is 'Значение';
comment on column fos.contragent_contacts.description is 'Описание';
comment on column fos.contragent_contacts.comments is 'Коменты';
comment on column fos.contragent_contacts.cu is 'Крайний изменивший';
comment on column fos.contragent_contacts.cd is 'Крайняя дата изменений';
comment on column fos.contragent_contacts.ct is 'Терминал';
comment on column fos.contragent_contacts.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.contragent_contacts
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

