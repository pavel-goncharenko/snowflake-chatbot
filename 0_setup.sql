create database role DEMO.DATA_DB_ROLE;
grant usage on database DEMO to database role DEMO.DATA_DB_ROLE;
grant usage on schema DEMO.SALES to database role DEMO.DATA_DB_ROLE;
grant select on all tables in schema DEMO.SALES to database role DEMO.DATA_DB_ROLE;

grant usage on schema DEMO.HR to database role DEMO.DATA_DB_ROLE;
grant select on all tables in schema DEMO.HR to database role DEMO.DATA_DB_ROLE;

grant usage on schema DEMO.SHARED to database role DEMO.DATA_DB_ROLE;
grant read on stage DEMO.SHARED.MY_IMAGES to database role DEMO.DATA_DB_ROLE;
