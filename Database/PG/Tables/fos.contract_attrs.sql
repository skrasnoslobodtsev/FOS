--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 01.07.2016
    Purpose   : Прочие атрибуты договора

Chnage list:
25.10.2016 Перепечко А.В. Добавляем ссылку на атрибут
21.05.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
21.05.2017 Перепечко А.В. Переносим на pg
25.06.2017 Перепечко А.В. Укорачиваем наименования служебных колонок
*/
--if OBJECT_ID( 'dbo.[contract_attrs]', 'U') is NOT NULL
--    drop table dbo.[contract_attrs];
--go
drop table fos.contract_attrs cascade;
/*
  Атрибуты:
    id                  - Уникальный идентификатор экземпляра
    -- Ссылки
    contract_id         - Ссылка на договор
    attr_item_id        - Ссылка на атрибут (справочник атрибутов)

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
create table fos.contract_attrs
(
    id                  bigint          NOT NULL,
    -- Ссылки
    contract_id         bigint          NOT NULL,
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
    constraint contract_attrs_pk primary key( id),
    constraint contract_attrs_fk_contract foreign key( contract_id) references fos.contracts( id),
    constraint constract_attrs_fk_attr_item foreign key( attr_item_id) references fos.dict_attr_items( id),
    constraint contract_attrs_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Ограничения проверки
    constraint contract_attrs_uk unique( contract_id, attr_item_id)
)
;

grant select on fos.contract_attrs to public;
grant select on fos.contract_attrs to fos_public;

comment on table fos.contract_attrs is 'Дополнительные атрибуты договора';

comment on column fos.contract_attrs.id is 'Уникальный идентификатор экземпляра';
comment on column fos.contract_attrs.contract_id is 'Ссылка на договор';
comment on column fos.contract_attrs.attr_item_id is 'Ссылка на доп.атрибут, справочник fos.dict_attr_items';
comment on column fos.contract_attrs.data is 'Значение';
comment on column fos.contract_attrs.description is 'Описание';
comment on column fos.contract_attrs.comments is 'Коменты';
comment on column fos.contract_attrs.cu is 'Крайний изменивший';
comment on column fos.contract_attrs.cd is 'Крайняя дата изменения';
comment on column fos.contract_attrs.ct is 'Терминал';
comment on column fos.contract_attrs.cu_id is 'Пользователь';

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
