truncate table buxton.sessions;
select * from buxton.sessions;

truncate table buxton.logs;
select * from buxton.logs;

truncate table buxton.activities;
select * from buxton.activities;

truncate table buxton.users;
select * from buxton.users;

-- Add 10 demo users
insert into buxton.users (email, type, trained)
values ('iain_wilkinson@blackradley.com', 'Administrator', 1);
insert into buxton.users (email, type, trained)
values ('peter_latchford@blackradley.com', 'Administrator', 1);
insert into buxton.users (email, type, trained)
values ('joe_collins@blackradley.com', 'Administrator', 1);

insert into buxton.users (email, trained)
values ('manager@blackradley.com', 1);
insert into buxton.users (email, trained)
values ('member@blackradley.com', 1);
insert into buxton.users (email, trained)
values ('quality@blackradley.com', 1);
insert into buxton.users (email, trained)
values ('senior@blackradley.com', 1);
insert into buxton.users (email, trained)
values ('corporate@blackradley.com', 1);
insert into buxton.users (email, trained)
values ('directorate@blackradley.com', 1);
insert into buxton.users (email, trained)
values ('development@blackradley.com', 1);

truncate table buxton.activity_strategies;
select * from buxton.activity_strategies;

truncate table buxton.comments;
select * from buxton.comments;

truncate table buxton.directorates;
select * from buxton.directorates;
insert into buxton.directorates (name)
values ('Demo Directorate');

truncate table buxton.service_areas;
insert into buxton.service_areas(directorate_id, approver_id, name)
values (1, 4, 'Demo Service Area 1');
insert into buxton.service_areas(directorate_id, approver_id, name)
values (1, 4, 'Demo Service Area 2');
select * from buxton.service_areas;

truncate table buxton.strategies;
insert into buxton.strategies(name, description)
values ('Be Healthy', 'Get some exercise and do not eat pies');
insert into buxton.strategies(name, description)
values ('Be Wealthy', 'Make a lot of money');
insert into buxton.strategies(name, description)
values ('Be Wise', 'Do not do anything stupid');
select * from buxton.strategies;

truncate table buxton.directorates_users;
insert into buxton.directorates_users(directorate_id, user_id)
values (1, 9);
select * from buxton.directorates_users;

truncate table buxton.functions;
truncate table buxton.function_strategies;
truncate table buxton.issues;
truncate table buxton.look_ups;
truncate table buxton.notes;
truncate table buxton.organisations;
truncate table buxton.organisation_terminologies;
truncate table buxton.projects;
truncate table buxton.task_group_memberships;
truncate table buxton.terminologies;