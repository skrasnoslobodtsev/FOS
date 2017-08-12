--use [template_db]
--go
/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 26.10.2016
    Purpose   : Страхование, справочник программ страхования (по сути это шаблон договора страхования)

Change list:
14.03.2017 Перепечко А.В. добавил ссылку на группу доп.атрибутов
11.08.2017 Перепечко А.В. Приводим к единому виду обязательных атрибутов (id, descr, comm, cu, cd, ct, cu_id)
11.08.2017 Перепечко А.В. Переносим на PG
*/
--if OBJECT_ID( 'dbo.dict_ins_programs', 'U') is NOT NULL
--    drop table dbo.dict_ins_programs;
drop table fos.dict_ins_programs cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра

        -- Ссылки
        ins_product_id          - Ссылка на серию
        attr_group_id           - Ссылка на группу дополнительных атрибутов договора страхования (ссылка копируется в новый дс)

        -- Атрибуты
        code                    - Код
        name                    - Наименование

        -- Не обязательные, но тоже есть у всех
        description             - Описание
        comments                - Коменты
        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.dict_ins_programs
(
    id                      bigint          NOT NULL,

    -- Ссылки
    ins_product_id          bigint          NOT NULL,
    attr_group_id           bigint          NULL,

    -- Атрибуты
    code                    varchar(50)     NOT NULL,
    name                    varchar(100)    NOT NULL,
    def_grr                 real            NULL,

    -- description and comments    
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,
    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------

    constraint dict_ins_programs_pk
        primary key ( id),
    -- Ссылки
    constraint dict_ins_programs_fk_ins_product
        foreign key( ins_product_id) references fos.dict_ins_products( id),
    constraint dict_ins_programs_fk_attr_group
        foreign key( attr_group_id) references fos.dict_attr_groups( id),
    constraint dict_ins_programs_fk_cu_id
        foreign key( cu_id) references fos.sys_users( id),
    -- Уникальность
    constraint dict_ins_programs_uk
        unique( ins_product_id, code),
    -- Проверки
    constraint dict_ins_programs_ch_def_grr
        check( ( def_grr is null) or ( def_grr > 0.0))
);

grant select on fos.dict_ins_programs to public;
grant select on fos.dict_ins_programs to fos_public;

comment on table fos.dict_ins_programs is 'Страхование, справочник программ страхования (по сути это шаблон договора страхования)';

comment on column fos.dict_ins_programs.id is 'Уникальный иденнтификатор экземпляра';
comment on column fos.dict_ins_programs.ins_product_id is 'Ссылка на продукт';
comment on column fos.dict_ins_programs.attr_group_id is 'Ссылка на группу атрибутов';
comment on column fos.dict_ins_programs.code is 'Код';
comment on column fos.dict_ins_programs.name is 'Наименованине';
comment on column fos.dict_ins_programs.def_grr is 'ГНД по умолчанию';
comment on column fos.dict_ins_programs.description is 'Описание';
comment on column fos.dict_ins_programs.comments is 'Коменнты';
comment on column fos.dict_ins_programs.cu is 'Крайний изменивший';
comment on column fos.dict_ins_programs.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_programs.ct is 'Теримнал';
comment on column fos.dict_ins_programs.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.dict_ins_programs
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
