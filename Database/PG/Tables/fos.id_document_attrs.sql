--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 25.10.2016
    Purpose   : Прочие атрибуты документа удостоверяющего личность

Change list:
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.[id_documents_attrs]', 'U') is NOT NULL
--    drop table dbo.[id_documents_attrs];
--go
drop table fos.id_document_attrs cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        contract_id         - Ссылка на договор
        attr_item_id        - Ссылка на атрибут

        -- Атрибуты
        data                - Значение атрибута

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.id_document_attrs
(
    id                  bigint          NOT NULL,
    -- Ссылки
    id_document_id      bigint          NOT NULL,
    attr_item_id        bigint          NOT NULL,

    -- Атрибуты
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
    constraint id_document_attrs_pk primary key ( id),
    constraint id_document_attrs_fk_contract foreign key( id_document_id) references fos.id_documents( id),
    constraint id_document_attrs_fk_attr_item foreign key( attr_item_id) references fos.dict_attr_items( id),
    constraint id_document_attrs_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Ограничения проверки
    constraint id_document_attrs_uk unique( id_document_id, attr_item_id)
)
;

grant select on fos.id_document_attrs to public;
grant select on fos.id_document_attrs to public;

comment on table fos.id_document_attrs is 'Дополнительные атрибуты документа УЛ';

comment on column fos.id_document_attrs.id is 'Уникальный идентификатор экземпляра';
comment on column fos.id_document_attrs.id_document_id is 'Ссылка на документ УЛ, fos.id_documents';
comment on column fos.id_document_attrs.attr_item_id is 'Ссылка на справочник атрибутов, fos.dict_attr_items';
comment on column fos.id_document_attrs.data is 'Значение атрибута';
comment on column fos.id_document_attrs.description is 'Описание';
comment on column fos.id_document_attrs.comments is 'Коменты';
comment on column fos.id_document_attrs.cu is 'Крайний изменивший';
comment on column fos.id_document_attrs.cd is 'Крайняя дата изменений';
comment on column fos.id_document_attrs.ct is 'Терминал';
comment on column fos.id_document_attrs.cu_id is 'Пользователь';

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
