--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 11.08.2017
    Purpose   : Страхование, риски в составе программы страхования

Change list:
12.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_program_risks', 'U') is NOT NULL
--    drop table dbo.dict_ins_program_risks;
drop table fos.dict_ins_program_risks cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра

        -- Ссылки
        ins_program_id          - Ссылка на серию
        ins_risk_id             - Ссылка на риск или группу рисков
        ins_type_id             - Ссылка на типизацию страхования ( dbo.dict_enum_items)
        proc_of_payment_id      - Ссылка на порядок выплат ( dbo.dict_enum_items)

        -- Атрибуты
        optional_flag           - Признак опциональности риска: 0 (default) - нет, 1 - да

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты
        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.dict_ins_program_risks
(
    id                      bigint          NOT NULL,

    -- Ссылки
    ins_program_id          bigint          NOT NULL,
    ins_risk_id             bigint          NOT NULL,
    ins_type_id             bigint          NOT NULL,
    proc_of_payment_id      bigint          NOT NULL,

    -- Атрибуты
    optional_flag           int             NOT NULL default 0,

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------

    constraint dict_ins_program_risks_pk
        primary key ( id),
    -- Ссылки
    constraint dict_ins_program_risks_fk_ins_program
        foreign key( ins_program_id) references fos.dict_ins_programs( id),
    constraint dict_ins_program_risks_fk_ins_risk
        foreign key( ins_risk_id) references fos.dict_ins_risks( id),
    constraint dict_ins_program_risks_fk_ins_type
        foreign key( ins_type_id) references fos.dict_enum_items( id),
    constraint dict_ins_program_risks_fk_proc_of_payment
        foreign key( proc_of_payment_id) references fos.dict_enum_items( id),
    constraint dict_ins_program_risks_fk_cu_id
        foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint dict_ins_program_risks_uk
        unique( ins_program_id, ins_risk_id)
    -- Проверки
);

grant select on fos.dict_ins_program_risks to public;
grant select on fos.dict_ins_program_risks to fos_public;

comment on table fos.dict_ins_program_risks is 'Страхование, риски в составе программы страхования';

comment on column fos.dict_ins_program_risks.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_program_risks.ins_program_id is 'Ссылка на программу страхования';
comment on column fos.dict_ins_program_risks.ins_risk_id is 'Ссылка на риск/группу рисков';
comment on column fos.dict_ins_program_risks.ins_type_id is 'Ссылка на тип страхования';
comment on column fos.dict_ins_program_risks.proc_of_payment_id is 'Ссылка на порядок выплат';
comment on column fos.dict_ins_program_risks.optional_flag is 'Признак опциональности (необязательности): 0 (default) - нет, 1 - да';
comment on column fos.dict_ins_program_risks.description is 'Описание';
comment on column fos.dict_ins_program_risks.comments is 'Коменты';
comment on column fos.dict_ins_program_risks.cu is 'Крайний изменивший';
comment on column fos.dict_ins_program_risks.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_program_risks.ct is 'Терминал';
comment on column fos.dict_ins_program_risks.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.dict_ins_program_risks with (nolock)
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
