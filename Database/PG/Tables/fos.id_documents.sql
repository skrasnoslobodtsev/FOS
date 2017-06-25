--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 25.10.2016
    Purpose   : Документы, удостоверения личности

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.[id_documents]', 'U') is NOT NULL
--    drop table dbo.[id_documents];
drop table fos.id_documents cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        kind_id             - Ссылка на вид документа удостоверения личности (простой справочник id_document_kinds)
        contragent_id       - Ссылка на контрагента

        -- Атрибуты
        doc_serie           - Серия документа
        doc_number          - Номер документа
        doc_date            - Когда выдан
        valid_from_date     - Дата начала валидности документа
        valid_till_date     - Дата окончания валидности документа
        doc_department      - Кем выдан
        doc_department_code - Код подразделения

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.id_documents
(
    id                  bigint          NOT NULL,
    -- Ссылки
    kind_id             bigint          NOT NULL,
    contragent_id       bigint          NOT NULL,
    -- Атрибуты
    doc_serie           varchar(50)     NULL,
    doc_number          varchar(100)    NULL,
    doc_date            timestamp       NULL,
    valid_from_date     timestamp       NULL,
    valid_till_date     timestamp       NULL,
    doc_department      varchar(100)    NULL,
    doc_department_code varchar(50)     NULL,
    primary_flag        int             NOT NULL constraint id_documents_df_pf default 0,

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint id_documents_pk primary key ( id),
    -- Ссылки
    constraint id_documents_fk_kind foreign key( kind_id) references fos.dict_enum_items( id),
    constraint id_documents_fk_contragent foreign key( contragent_id) references fos.contragents( id),
    constraint id_documents_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint id_documents_uk unique( kind_id, doc_serie, doc_number)
)
;

grant select on fos.id_documents to public;
grant select on fos.id_documents to fos_public;

comment on table fos.id_documents is 'Удостоверения личности контрагента';

comment on column fos.id_documents.id is 'Никальный идентификатор экземпляра';
comment on column fos.id_documents.kind_id is 'Ссылка на вид документа, справочник fos.dict_enum_items';
comment on column fos.id_documents.contragent_id is 'Ссылка на контрагента';
comment on column fos.id_documents.doc_serie is 'Серия';
comment on column fos.id_documents.doc_number is 'Номер';
comment on column fos.id_documents.doc_date is 'Дата';
comment on column fos.id_documents.valid_from_date is 'Годен с даты';
comment on column fos.id_documents.valid_till_date is 'Годен до даты';
comment on column fos.id_documents.doc_department is 'Кем выдан';
comment on column fos.id_documents.doc_department_code is 'Код подразделения';
comment on column fos.id_documents.primary_flag is 'Признак основного документа: 0 (default) - нет, 1 - да';
comment on column fos.id_documents.description is 'Описание';
comment on column fos.id_documents.comments is 'Коментарии';
comment on column fos.id_documents.cu is 'Крайний изменивший';
comment on column fos.id_documents.cd is 'Крайняя дата изменений';
comment on column fos.id_documents.ct is 'Терминал';
comment on column fos.id_documents.cu_id is 'Пользователь';

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
