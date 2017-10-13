/*
    Developer : Перепечко А.В.
    Created   : 06.10.2017
    Purpose   : Накат изменений от 06.10.2017
*/
alter table fos.contragents add j_descr varchar(100) null;
alter table fos.contragents add root_id bigint not null;
alter table fos.contragents add prior_version_id bigint null;
alter table fos.contragents add next_version_id bigint null;
alter table fos.contragents add delete_flag int not null default 0;
alter table fos.contragents add constraint contragents_fk_root foreign key ( root_id) references fos.contragents( id);
alter table fos.contragents add constraint contragents_fk_prior_version foreign key( prior_version_id) references fos.contragents( id);
alter table fos.contragents add constraint contragents_fk_next_version foreign key( next_version_id) references fos.contragents( id);
alter table fos.contragents add constraint contragents_ch_df check( delete_flag in ( 0, 1));
alter table fos.contragents drop constraint contragents_uk_itn;
drop index fos.contragents_idx_norm_name;

alter table fos.dict_enums add delete_flag int not null default 0;
alter table fos.dict_enums add constraint dict_enums_ch_df check( delete_flag in ( 0, 1));
alter table fos.dict_enums add root_id bigint not null;
alter table fos.dict_enums add constraint dict_enums_fk_root foreign key( root_id) references fos.dict_enums( id);
alter table fos.dict_enums add prior_version_id bigint null;
alter table fos.dict_enums add next_version_id bigint null;
alter table fos.dict_enums add constraint dict_enums_fk_prior_version foreign key( prior_version_id) references fos.dict_enums( id);
alter table fos.dict_enums add constraint dict_enums_fk_next_version foreign key( next_version_id) references fos.dict_enums( id);

alter table fos.dict_attr_groups add root_id bigint not null;
alter table fos.dict_attr_groups add prior_version_id bigint null;
alter table fos.dict_attr_groups add next_version_id bigint null;
alter table fos.dict_attr_groups add delete_flag int not null default 0;
alter table fos.dict_attr_groups add constraint dict_attr_groups_fk_root foreign key( root_id) references fos.dict_attr_groups( id);
alter table fos.dict_attr_groups add constraint dict_attr_groups_fk_prior_version foreign key( prior_version_id) references fos.dict_attr_groups( id);
alter table fos.dict_attr_groups add constraint dict_attr_groups_fk_next_version foreign key( next_version_id) references fos.dict_attr_groups( id);
alter table fos.dict_attr_groups drop constraint dict_attr_groups_uk;

alter table fos.dict_countries add root_id bigint not null;
alter table fos.dict_countries add prior_version_id bigint null;
alter table fos.dict_countries add next_version_id bigint null;
alter table fos.dict_countries add delete_flag int not null default 0;
alter table fos.dict_countries add constraint dict_countries_ch_df check( delete_flag in ( 0, 1));
