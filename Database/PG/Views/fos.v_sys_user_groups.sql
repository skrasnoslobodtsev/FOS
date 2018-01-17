/*
    Developer : Перепечко А.В.
    Created   : 14.01.2018
    Purpose   : Пользовательские группы

Change list:
*/
/*
    Атрибуты:
        id                          - Уникальный идентификатор экземпляра
        sys_user_id                 - Ссылка на пользователя
        sys_user_name               - Пользователь
        operator                    - ФИО/наименование пользователя
        sys_group_id                - Ссылка на группу
        sys_group_code              - Код группы
        sys_group_name              - Группа
        description                 - Описание
        comments                    - Коменты
        cu                          - Пользователь
        cd                          - Дата
        ct                          - Терминал
        cu_id                       - Ссылка на пользователя системы
*/
drop view if exists fos.v_sys_user_groups cascade;

create or replace view fos.v_sys_user_groups
as
select
    sug.id,
    sug.sys_user_id,
    su.username as sys_user_name,
    su.operator,
    sug.sys_group_id,
    sg.code as sys_group_code,
    sg.name as sys_group_name,
    sug.description,
    sug.comments,
    sug.cu,
    sug.cd,
    sug.ct,
    sug.cu_id
from
    fos.sys_user_groups sug
    inner join
        fos.sys_users su
        on
            su.id = sug.sys_user_id
    inner join
        fos.sys_groups sg
        on
            sg.id = sug.sys_group_id
;

grant select on fos.v_sys_user_groups to public;
grant select on fos.v_sys_user_groups to fos_public;

comment on view fos.v_sys_user_groups is 'Пользовательские группы';

comment on column fos.v_sys_user_groups.id is 'Уникальный идентификатор экземпляра';
comment on column fos.v_sys_user_groups.sys_user_id is 'Ссылка на пользователя системы';
comment on column fos.v_sys_user_groups.sys_user_name is 'Пользователь системы';
comment on column fos.v_sys_user_groups.operator is 'ФИО/наименование пользователя системы';
comment on column fos.v_sys_user_groups.sys_group_id is 'Ссылка на группу';
comment on column fos.v_sys_user_groups.sys_group_code is 'Код группы';
comment on column fos.v_sys_user_groups.sys_group_name is 'Группа';
comment on column fos.v_sys_user_groups.description is 'Описание';
comment on column fos.v_sys_user_groups.comments is 'Коментарии';
comment on column fos.v_sys_user_groups.cu is 'Поьлзователь БД';
comment on column fos.v_sys_user_groups.cd is 'Дата';
comment on column fos.v_sys_user_groups.ct is 'Терминал';
comment on column fos.v_sys_user_groups.cu_id is 'Ссылка на пользователя';

/* test

select
    *
from
    fos.v_sys_user_groups
;

-- SQL запросы


*/