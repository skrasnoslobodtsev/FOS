--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 10.03.2017
    Purpose   : Объекты учёта, страхователи

Change list:
12.08.2017 Перепечко А.В. добиваем атрибуты
12.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.ins_insurers', 'U') is NOT NULL
--    drop table dbo.ins_insurers;
--go
drop table fos.ins_insurers cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра

        -- Ссылки
        ins_conract_id          - Ссылка на договор страхования
        contragent_id           - Ссылка на контрагента

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
    ins_contract_id     bigint          NOT NULL,
    contragent_id       bigint          NOT NULL,

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
    constraint ins_insurers_fk_ins_contract foreign key ( ins_contract_id) references fos.ins_contracts( id),
    constraint ins_insurers_fk_contragent foreign key ( contragent_id) references fos.contragents( id),
    constraint ins_insurers_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint ins_insurers_uk unique( ins_contract_id)
);

grant select on fos.ins_insurers to public;
grant select on fos.ins_insurers to fos_public;

comment on table fos.ins_insurers is 'Объекты учёта, страхователи';

comment on column fos.ins_insurers.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_insurers.ins_contract_id is 'Ссылка на договор страхования';
comment on column fos.ins_insurers.contragent_id is 'Ссылка на контрагента';
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
