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
alter table fos.dict_enums drop constraint dict_enums_uk_code;
alter table fos.dict_enums add version_index int not null default 0;
alter table fos.dict_enums add constraint dict_enums_uk_code unique( code, branch_id, version_index);

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
alter table fos.dict_countries drop constraint dict_countries_uk;
alter table fos.dict_countries add version_index int not null default 0;
alter table fos.dict_countries add constraint dict_countries_uk_version unique( root_id, version_index);
alter table fos.dict_countries add constraint dict_countries_uk unique( version_index, code_3);

alter table fos.dict_currencies add root_id bigint not null;
alter table fos.dict_currencies add prior_version_id bigint null;
alter table fos.dict_currencies add next_version_id bigint null;
alter table fos.dict_currencies add delete_flag int not null default 0;
alter table fos.dict_currencies add version_index int not null default 0;
alter table fos.dict_currencies drop constraint dict_currencies_uk_code;
alter table fos.dict_currencies drop constraint dict_currencies_uk_num;
alter table fos.dict_currencies add constraint dict_currencies_uk_code unique ( version_index, iso_code);
alter table fos.dict_currencies add constraint dict_currencies_uk_num unique( version_index, num_code);

alter table fos.dict_ins_agents add root_id bigint not null;
alter table fos.dict_ins_agents add prior_version_id bigint null;
alter table fos.dict_ins_agents add next_version_id bigint null;
alter table fos.dict_ins_agents add version_index int not null default 0;
alter table fos.dict_ins_agents add delete_flag int not null default 0;
alter table fos.dict_ins_agents drop constraint dict_ins_agents_uk_code;
alter table fos.dict_ins_agents add constraint dict_ins_agents_uk_code unique ( code, branch_id, version_index);
