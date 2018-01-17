﻿--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 29.11.2016
    Purpose   : Страхование, справочник страховых рисков и групп рисков

Change list:
09.03.2017 Перепечко А.В. Замена dbo.dicts на dbo.dict_enums
11.08.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
11.08.2017 Перепечко А.В. Переделываем справочник рисков на риски и группы рисков (деревянный справочник)
11.08.2017 Перепечко А.В. Переносим на PG
14.01.2018 Перепечко А.В. Добавляем ссылки на корень, след и пред версии, признак удаления, вид группы (дожитие, смерть, etc)
*/
--if OBJECT_ID( 'dbo.dict_ins_risks', 'U') is NOT NULL
--    drop table dbo.dict_ins_risks;
drop table if exists fos.dict_ins_risks cascade;
/*
    Атрибуты:
        id                  - Уникальный идентификатор экземпляра
        -- Ссылки
        root_id             - Ссылка на корневую версию
        prior_version_id    - Ссылка на предыдущую версию
        next_version_id     - Ссылка на следующую версию

        branch_id           - Ссылка на филиал
        def_ins_type_id     - Ссылка на типизацию страхования, простые справочники( dbo.v_dict_ins_types)
        def_group_kind_id   - Ссылка на вид группы, справочник dict_enums (вид группы рисков: дожитие, смерть, etc.)

        -- Атрибуты
        code                - Код
        name                - Наименование
        group_flag          - Признак группы рисков: 0 (default) - нет, 1 - да
        active_flag         - Признак активности: 0 - нет, 1 (default) - Да


        -- Не обязательные, но тоже есть у всех
        description         - Описание
        comments            - Коменты
        -- Системные
        cu                  - Пользователь
        cd                  - Дата последнего изменения
        ct                  - Терминал
        cu_id               - Ссылка на юзверя
*/
create table fos.dict_ins_risks
(
    id                  bigint          NOT NULL,
    -- Ссылки
    root_id             bigint          not null,
    prior_version_id    bigint          null,
    next_version_id     bigint          null,

    branch_id           bigint          NULL,
    def_ins_type_id     bigint          NULL,
    def_group_kind_id   bigint          null,
    -- Атрибуты
    code                varchar(50)     NOT NULL,
    name                varchar(100)    NOT NULL,
    group_flag          int             NOT NULL default 0,
    active_flag         int             NOT NULL default 1,

    -- description and comments    
    delete_flag         int             not null default 0,
    description         varchar(500)    NULL,
    comments            varchar(1000)   NULL,
    -- system info
    cu                  varchar(256)    NOT NULL default session_user,
    cd                  timestamp       NOT NULL default current_timestamp,
    ct                  varchar(256)    NOT NULL default inet_client_addr(),
    cu_id               bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_ins_risks_pk primary key ( id),
    -- Ссылки
    constraint dict_ins_risks_fk_branch foreign key( branch_id) references fos.branches( id),
    constraint dict_ins_risks_fk_def_ins_type foreign key( def_ins_type_id) references fos.dict_enum_items( id),
    constraint dict_ins_risks_fk_def_group_kind foreign key( def_group_kind_id) references fos.dict_enum_items( id),
    constraint dict_ins_risks_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
--    constraint dict_ins_risks_uk_code
--        unique ( code, branch_id),
    -- Проверки
    constraint dict_ins_risks_ch_af check( active_flag in ( 0, 1)),
    constraint dict_ins_risks_ch_gf check( group_flag in ( 0, 1)),
    constraint dict_ins_risks_ch_df check( delete_flag in ( 0, 1))
);

alter table fos.dict_ins_risks 
    add constraint dict_ins_risks_fk_root
        foreign key( root_id) references fos.dict_ins_risks( id);
alter table fos.dict_ins_risks
    add constraint dict_ins_risks_fk_prior_version
        foreign key( prior_version_id) references fos.dict_ins_risks( id);
alter table fos.contragents
    add constraint dict_ins_risks_fk_next_version
        foreign key( next_version_id) references fos.dict_ins_risks( id);

grant select on fos.dict_ins_risks to public;
grant select on fos.dict_ins_risks to fos_public;

comment on table fos.dict_ins_risks is 'Страхование, справочник страховых рисков и групп рисков';

comment on column fos.dict_ins_risks.id is 'Уникальнный идентификатор филиала';
comment on column fos.dict_ins_risks.root_id is 'Ссылка на корневую версию';
comment on column fos.dict_ins_risks.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.dict_ins_risks.next_version_id is 'Ссылка на следующую версию';
comment on column fos.dict_ins_risks.branch_id is 'Ссылка на филиал';
comment on column fos.dict_ins_risks.def_ins_type_id is 'Ссылка на тип страхования по умолчанию для риска';
comment on column fos.dict_ins_risks.def_group_kind_id is 'Ссылка на вид группы, справочник dict_enums (вид группы рисков: дожитие, смерть, etc.)';
comment on column fos.dict_ins_risks.code is 'Код';
comment on column fos.dict_ins_risks.name is 'Наименование';
comment on column fos.dict_ins_risks.group_flag is 'Признак группы: 0 (default) - нет, 1 - да';
comment on column fos.dict_ins_risks.active_flag is 'Признак активности: 0 - нет, 1 (default) - да';
comment on column fos.dict_ins_risks.description is 'Описание';
comment on column fos.dict_ins_risks.comments is 'Коменты';
comment on column fos.dict_ins_risks.cu is 'Крайнинй изменивший';
comment on column fos.dict_ins_risks.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_risks.ct is 'Терминал';
comment on column fos.dict_ins_risks.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    dbo.dict_ins_risks with (nolock)
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
