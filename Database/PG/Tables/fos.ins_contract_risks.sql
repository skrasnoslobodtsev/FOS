--use template_db;
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 16.08.2017
    Purpose   : Объекты учёта, риски договора страхования

Change list:
16.08.2017 Перепечко А.В. Перенносим на PG
*/
--if OBJECT_ID( 'dbo.ins_contract_risks', 'U') is NOT NULL
--    drop table dbo.ins_contract_risks
--go
drop table fos.ins_contract_risks cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        ins_contract_id         - Ссылка на договор страхования
        ins_program_risk_id     - Ссылка на риск программы страхования
        ins_type_id             - Ссылка на типизацию страхования, dbo.dict_enum_items

        -- Атрибуты
        underwriter_factor      - Коээфициент андеррайтера

        -- Признаки

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты
        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.ins_contract_risks
(
    id                      bigint          NOT NULL,
    -- Ссылки
    ins_contract_id         bigint          NOT NULL,
    ins_program_risk_id     bigint          NOT NULL,
    ins_type_id             bigint          NOT NULL,
    proc_of_payment_id      bigint          NOT NULL,

    -- Атрибуты
    underwriter_factor      real            NULL default 1.0,

    -- Признаки

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------
    constraint ins_contract_risks_pk primary key ( id),
    -- Ссылки
    constraint ins_contract_risks_fk_ins_contract foreign key( id) references fos.ins_contracts( id),
    constraint ins_contract_risks_fk_ins_program_risk foreign key( ins_program_risk_id) references fos.dict_ins_program_risks( id),
    constraint ins_contract_risks_fk_ins_type foreign key( ins_type_id) references fos.dict_enum_items( id),
    constraint ins_contract_risks_fk_proc_of_payment foreign key( proc_of_payment_id) references fos.dict_enum_items( id),
    constraint ins_contract_risks_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Ограничения проверки
    constraint ins_contract_risks_ch_uf check( ( underwriter_factor is null) or ( underwriter_factor > 0.0))
);

grant select on fos.ins_contract_risks to public;
grant select on fos.ins_contract_risks to fos_public;


comment on table fos.ins_contract_risks is 'Объекты учёта, риски договора страхования';

comment on column fos.ins_contract_risks.id is 'Уникальный идентификатор экземпляра';
comment on column fos.ins_contract_risks.ins_contract_id is 'Ссылка на договор страхования';
comment on column fos.ins_contract_risks.ins_program_risk_id is 'Ссылка на риск программы страхования';
comment on column fos.ins_contract_risks.ins_type_id is 'Ссылка на типизацю страхования';
comment on column fos.ins_contract_risks.proc_of_payment_id is 'Ссылка порядок выплат';
comment on column fos.ins_contract_risks.underwriter_factor is 'Коэффициент андеррайтера';
comment on column fos.ins_contract_risks.description is 'Описание';
comment on column fos.ins_contract_risks.comments is 'Коменты';
comment on column fos.ins_contract_risks.cu is 'Крайний изменивший';
comment on column fos.ins_contract_risks.cd is 'Крайняя дата изменений';
comment on column fos.ins_contract_risks.ct is 'Терминал';
comment on column fos.ins_contract_risks.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.ins_contract_risks with (nolock)
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
