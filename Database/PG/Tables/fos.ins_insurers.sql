--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 10.03.2017
    Purpose   : Объекты учёта, страхователи

Change list:
12.08.2017 Перепечко А.В. добиваем атрибуты
12.08.2017 Перепечко А.В. Переносим на PG
14.01.2018 Перепечко А.В. Добиваем поля
*/
--if OBJECT_ID( 'dbo.ins_insurers', 'U') is NOT NULL
--    drop table dbo.ins_insurers;
--go
drop table if exists fos.ins_insurers cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра

        -- Ссылки
        root_id                 - Ссылка на корневую версию
        prior_version_id        - Ссылка на предыдущую версию
        next_version_id         - Ссылка на следующую версию

        contragent_id           - Ссылка на контрагента
        id_document_id          - Ссылка на УД

        -- Атрибуты
        -- ..

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты
        
        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.ins_insurers
(
    id                  bigint          NOT NULL,
    -- Ссылки
    root_id             bigint          null,
    prior_version_id    bigint          null,
    next_version_id     bigint          null,

    contragent_id       bigint          NOT NULL,
    id_document_id      bigint          null,

    -- Атрибуты
    -- ..

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,

    -- constraints ---------------------------------------------
    constraint ins_insurers_pk primary key ( id),
    -- Ссылки
    constraint ins_insurers_fk_contragent foreign key ( contragent_id) references fos.contragents( id),
    constraint ins_insurers_fk_id_document foreign key( id_document_id) references fos.id_documents( id),
    constraint ins_insurers_fk_cu_id foreign key( cu_id) references fos.sys_users( id)
    -- Уникальность
);

alter table fos.ins_insurers
    add constraint ins_insures_fk_root
        foreign key( root_id) references fos.ins_insurers( id);
alter table fos.ins_insurers
    add constraint ins_insures_fk_prior_version
        foreign key( prior_version_id) references fos.ins_insurers( id);
alter table fos.ins_insurers
    add constraint ins_insures_fk_next_version
        foreign key( next_version_id) references fos.ins_insurers( id);


grant select on fos.ins_insurers to public;
grant select on fos.ins_insurers to fos_public;

comment on table fos.ins_insurers is 'Объекты учёта, страхователи';

comment on column fos.ins_insurers.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_insurers.root_id is 'Ссылка на корневую версию';
comment on column fos.ins_insurers.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.ins_insurers.next_version_id is 'Ссылка на следующую версию';
comment on column fos.ins_insurers.contragent_id is 'Ссылка на контрагента';
comment on column fos.ins_insurers.id_document_id is 'Ссылка на УД';
comment on column fos.ins_insurers.description is 'Описание';
comment on column fos.ins_insurers.comments is 'Коменты';
comment on column fos.ins_insurers.cu is 'Крайний изменивший';
comment on column fos.ins_insurers.cd is 'Крайняя дата изменений';
comment on column fos.ins_insurers.ct is 'Терминал';
comment on column fos.ins_insurers.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.ins_insurers with (nolock)
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
