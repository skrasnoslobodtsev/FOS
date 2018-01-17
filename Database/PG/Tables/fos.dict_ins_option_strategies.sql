/* Сгенерировано из шаблона
    Developer : Перепечко А.В.
    Created   : 17.01.2017
    Purpose   : Страхование, справочник стратегий

Change list:
*/
drop table if exists fos.dict_ins_option_strategies cascade;
/*
    Атрибуты:
        id                      - Уникальный идентификатор экземпляра
        -- Ссылки
        branch_id               - Ссылка на филиал
        root_id                 - Ссылка на первую версию
        prior_version_id        - Ссылка на предыдущую версию
        next_version_id         - Ссылка на след.версию

        -- Атрибуты
        code                    - Код
        name                    - Наименование

        -- Признаки

        -- Не обязательные, но тоже есть у всех
        delete_flag             - Признак удаления: 0 (default) - нет, 1 - да
        description             - Описание
        comments                - Коменты

        -- Системные
        cu                      - Пользователь
        cd                      - Дата последнего изменения
        ct                      - Терминал
        cu_id                   - Ссылка на юзверя
*/
create table fos.dict_ins_option_strategies
(
    id                      bigint          NOT NULL,
    -- Ссылки
    branch_id               bigint          NULL,
    root_id                 bigint          NULL,
    prior_version_id        bigint          NULL,
    next_version_id         bigint          NULL,

    -- Атрибуты
    code                    varchar(50)     not null,
    name                    varchar(100)    null,

    -- Признаки

    -- description and comments    
    delete_flag             int             not null default 0,
    description             varchar(500)    NULL,
    comments                varchar(1000)   NULL,

    -- system info
    cu                      varchar(256)    NOT NULL default session_user,
    cd                      timestamp       NOT NULL default current_timestamp,
    ct                      varchar(256)    NOT NULL default inet_client_addr(),
    cu_id                   bigint          NULL,
    -- constraints ---------------------------------------------
    constraint dict_ins_option_strategies_pk primary key ( id),
    -- Ссылки
    constraint dict_ins_option_strategies_fk_branch foreign key( branch_id) references fos.branches( id),
    constraint dict_ins_option_strategies_fk_cu_id foreign key( cu_id) references fos.sys_users( id),
    -- Ссылки на версии
    constraint dict_ins_option_strategies_fk_root foreign key( root_id) references fos.dict_ins_option_strategies( id),
    constraint dict_ins_option_strategies_fk_prior_version foreign key( prior_version_id) references fos.dict_ins_option_strategies( id),
    constraint dict_ins_option_strategies_fk_next_version foreign key( next_version_id) references fos.dict_ins_option_strategies( id),
    -- Ограничения проверки
    constraint dict_ins_option_strategies_ch_df check( delete_flag in ( 0, 1))
);

grant select on fos.dict_ins_option_strategies to public;
grant select on fos.dict_ins_option_strategies to fos_public;

comment on table fos.dict_ins_option_strategies is 'Страхование, справочник стратегий опционов';

comment on column fos.dict_ins_option_strategies.id is 'Уникальный идентификатор экземпляра';
comment on column fos.dict_ins_option_strategies.branch_id is 'Ссылка на филиал';
comment on column fos.dict_ins_option_strategies.root_id is 'Ссылка на корневую версию';
comment on column fos.dict_ins_option_strategies.prior_version_id is 'Ссылка на предыдущую версию';
comment on column fos.dict_ins_option_strategies.next_version_id is 'Ссылка на следующую версию';
comment on column fos.dict_ins_option_strategies.code is 'Код';
comment on column fos.dict_ins_option_strategies.name is 'Наименование';
comment on column fos.dict_ins_option_strategies.delete_flag is 'Признак удаления: 0 (default) - нет, 1 - да';
comment on column fos.dict_ins_option_strategies.description is 'Описание';
comment on column fos.dict_ins_option_strategies.comments is 'Коменты';
comment on column fos.dict_ins_option_strategies.cu is 'Крайний изменивший';
comment on column fos.dict_ins_option_strategies.cd is 'Крайняя дата изменений';
comment on column fos.dict_ins_option_strategies.ct is 'Терминал';
comment on column fos.dict_ins_option_strategies.cu_id is 'Пользователь';

/*  
-- Проверка
select
    *
from
    fos.dict_ins_option_strategies
;

-- SQL запросы 
select
    error_code,
    error_message
from 
    fos.sys_errors
order by 
    error_code desc
;

select
    *
from 
    fos.sys_settings
;

*/
