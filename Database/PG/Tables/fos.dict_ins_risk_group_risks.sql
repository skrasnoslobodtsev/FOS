--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 11.08.2017
    Purpose   : Страхование, риски в составе групп рисков

Change list:
11.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_risk_group_risks', 'U') is NOT NULL
--    drop table dbo.dict_ins_risk_group_risks;
drop table fos.dict_ins_risk_group_risks cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        risk_group_id       - Ссылка на филиал
        risk_id             - Ссылка на риск

        -- Атрибуты
        code                - Код
        name                - Наименование

        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.dict_ins_risk_group_risks
(
    id                  bigint          NOT NULL,
    -- Ссылки
    risk_group_id       bigint          NOT NULL,
    risk_id             bigint          NOT NULL,
    -- Атрибуты

    -- description and comments    
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,

    -- constraints ---------------------------------------------
    constraint dict_ins_risk_group_risks_pk
        primary key ( id),
    -- Ссылки
    constraint dict_ins_risk_group_risks_group
        foreign key( risk_group_id) references fos.dict_ins_risks( id),
    constraint dict_ins_risk_group_risks_risk
        foreign key( risk_id) references fos.dict_ins_risks( id),
    -- Уникальность
    constraint dict_ins_risk_group_risks_uk
        unique( risk_group_id, risk_id),
    -- Проверки
    constraint dict_ins_risk_group_risks_ch
        check( risk_group_id != risk_id)
);

grant select on fos.dict_ins_risk_group_risks to public;
grant select on fos.dict_ins_risk_group_risks to fos_public;

comment on table fos.dict_ins_risk_group_risks is 'Страхование, риски в составе групп рисков';

comment on column fos.dict_ins_risk_group_risks.id is 'Уникальный иденнтификатор экземпляра';
comment on column fos.dict_ins_risk_group_risks.risk_group_id is 'Ссылка на группу рисков';
comment on column fos.dict_ins_risk_group_risks.risk_id is 'Ссылка на риск';
comment on column fos.dict_ins_risk_group_risks.description is 'Описание';
comment on column fos.dict_ins_risk_group_risks.comments is 'Коментарии';
comment on column fos.dict_ins_risk_group_risks.cu is 'Крайний изменивший';
comment on column fos.dict_ins_risk_group_risks.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_risk_group_risks.ct is 'Терминал';
comment on column fos.dict_ins_risk_group_risks.cu_id is 'Пользователь';

/*  
-- Проверка

select
    *
from
    dbo.dict_ins_risk_group_risks with (nolock)
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
