ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- for workspaces
CREATE API INTEGRATION github_llm
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/pavel-goncharenko')
  ENABLED = TRUE;

-- loading json5 later
GRANT DATABASE ROLE SNOWFLAKE.PYPI_REPOSITORY_USER TO ROLE PUBLIC;

--- DEMO database from https://codemie.lab.epam.com/#/share/conversations/MazvXyg3gLbx

CREATE DATABASE DEMO;

CREATE SCHEMA DEMO.SALES;
USE SCHEMA DEMO.SALES;

CREATE OR REPLACE TABLE DIM_CUSTOMER (
    CUSTOMER_ID NUMBER PRIMARY KEY,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    CITY STRING,
    SEGMENT STRING
);

INSERT INTO DIM_CUSTOMER VALUES
(1, 'Alice', 'Moreno', 'Seattle', 'Consumer'),
(2, 'Brian', 'Wu', 'Denver', 'Corporate'),
(3, 'Chloe', 'Patel', 'Austin', 'Small Business'),
(4, 'David', 'Nguyen', 'Boston', 'Consumer'),
(5, 'Elena', 'Garcia', 'Miami', 'Corporate'),
(6, 'Farhan', 'Ali', 'Chicago', 'Consumer'),
(7, 'Grace', 'Lee', 'San Francisco', 'Small Business'),
(8, 'Hannah', 'Kim', 'Portland', 'Home Office'),
(9, 'Isaac', 'Young', 'Dallas', 'Consumer'),
(10, 'Julia', 'Williams', 'Atlanta', 'Home Office');

CREATE OR REPLACE TABLE DIM_PRODUCT (
    PRODUCT_ID NUMBER PRIMARY KEY,
    PRODUCT_NAME STRING,
    CATEGORY STRING,
    BRAND STRING,
    PRICE NUMBER(8,2)
);

INSERT INTO DIM_PRODUCT VALUES
(101, 'Wireless Mouse', 'Accessories', 'LogiTech', 23.99),
(102, 'Laptop 14"', 'Computers', 'Dell', 779.00),
(103, 'Monitor 27"', 'Electronics', 'LG', 219.99),
(104, 'Tablet 10"', 'Electronics', 'Apple', 429.99),
(105, 'Webcam', 'Accessories', 'Microsoft', 49.99),
(106, 'Desk Chair', 'Furniture', 'IKEA', 129.00),
(107, 'Desk Lamp', 'Office', 'Philips', 28.50),
(108, 'Smartphone', 'Electronics', 'Samsung', 599.00),
(109, 'Keyboard', 'Accessories', 'LogiTech', 35.99),
(110, 'Speakers', 'Electronics', 'Bose', 89.99);

CREATE OR REPLACE TABLE DIM_STORE (
    STORE_ID NUMBER PRIMARY KEY,
    STORE_NAME STRING,
    CITY STRING,
    STATE STRING
);

INSERT INTO DIM_STORE VALUES
(11, 'Tech Plaza', 'Seattle', 'WA'),
(12, 'Gadget Central', 'Denver', 'CO'),
(13, 'Device Hub', 'Austin', 'TX'),
(14, 'Digital Station', 'Boston', 'MA'),
(15, 'Electro Mart', 'Miami', 'FL'),
(16, 'Smart Devices', 'Chicago', 'IL'),
(17, 'Bay Tech', 'San Francisco', 'CA'),
(18, 'Northwest Electronics', 'Portland', 'OR'),
(19, 'Tech Market', 'Dallas', 'TX'),
(20, 'Innovate Store', 'Atlanta', 'GA');

CREATE OR REPLACE TABLE FACT_SALES_ORDER (
    ORDER_ID NUMBER PRIMARY KEY,
    ORDER_DATE DATE,
    CUSTOMER_ID NUMBER,
    STORE_ID NUMBER,
    TOTAL_AMOUNT NUMBER(10,2)
);

INSERT INTO FACT_SALES_ORDER VALUES
(1001, '2023-01-02', 1, 11, 324.97),
(1002, '2023-01-04', 6, 16, 819.00),
(1003, '2023-01-05', 3, 13, 23.99),
(1004, '2023-01-07', 4, 14, 219.99),
(1005, '2023-01-10', 7, 17, 28.50),
(1006, '2023-01-13', 9, 19, 129.00),
(1007, '2023-01-13', 2, 12, 839.99),
(1008, '2023-01-13', 10, 20, 779.00),
(1009, '2023-01-14', 5, 15, 429.99),
(1010, '2023-01-18', 8, 18, 49.99),
(1011, '2023-01-19', 2, 11, 23.99),
(1012, '2023-01-21', 3, 16, 129.00),
(1013, '2023-01-21', 7, 14, 89.99),
(1014, '2023-01-22', 1, 13, 23.99),
(1015, '2023-01-23', 5, 15, 219.99),
(1016, '2023-01-24', 8, 18, 35.99),
(1017, '2023-01-25', 9, 19, 89.99),
(1018, '2023-01-26', 4, 12, 599.00),
(1019, '2023-01-27', 2, 13, 429.99),
(1020, '2023-01-28', 10, 20, 779.00),
(1021, '2023-01-29', 1, 11, 28.50),
(1022, '2023-01-29', 6, 16, 819.00),
(1023, '2023-01-30', 3, 14, 23.99),
(1024, '2023-01-31', 8, 18, 49.99),
(1025, '2023-02-01', 5, 15, 219.99),
(1026, '2023-02-01', 2, 12, 839.99),
(1027, '2023-02-02', 1, 11, 129.00),
(1028, '2023-02-05', 9, 19, 89.99),
(1029, '2023-02-05', 4, 14, 599.00),
(1030, '2023-02-06', 10, 20, 35.99);

CREATE OR REPLACE TABLE FACT_ORDER_ITEM (
    ORDER_ITEM_ID NUMBER PRIMARY KEY,
    ORDER_ID NUMBER,
    PRODUCT_ID NUMBER,
    QUANTITY NUMBER,
    UNIT_PRICE NUMBER(8,2)
);

INSERT INTO FACT_ORDER_ITEM VALUES
(5001, 1001, 101, 2, 23.99),
(5002, 1001, 109, 2, 35.99),
(5003, 1001, 106, 1, 129.00),
(5004, 1002, 102, 1, 779.00),
(5005, 1002, 105, 1, 49.99),
(5006, 1003, 101, 1, 23.99),
(5007, 1004, 103, 1, 219.99),
(5008, 1005, 107, 1, 28.50),
(5009, 1006, 106, 1, 129.00),
(5010, 1007, 104, 1, 429.99),
(5011, 1007, 108, 1, 399.00),
(5012, 1008, 102, 1, 779.00),
(5013, 1009, 104, 1, 429.99),
(5014, 1010, 105, 1, 49.99),
(5015, 1011, 101, 1, 23.99),
(5016, 1012, 106, 1, 129.00),
(5017, 1013, 110, 1, 89.99),
(5018, 1014, 101, 1, 23.99),
(5019, 1015, 103, 1, 219.99),
(5020, 1016, 109, 1, 35.99),
(5021, 1017, 110, 1, 89.99),
(5022, 1018, 108, 1, 599.00),
(5023, 1019, 104, 1, 429.99),
(5024, 1020, 102, 1, 779.00),
(5025, 1021, 107, 1, 28.50),
(5026, 1022, 102, 1, 779.00),
(5027, 1022, 105, 1, 40.00),
(5028, 1023, 101, 1, 23.99),
(5029, 1024, 105, 1, 49.99),
(5030, 1025, 103, 1, 219.99);

-------

-- https://codemie.lab.epam.com/#/share/conversations/sXrMzfyhMqG1


CREATE SCHEMA DEMO.HR;
USE SCHEMA DEMO.HR;

CREATE OR REPLACE TABLE EMPLOYEE (
  EMPLOYEE_ID    INTEGER PRIMARY KEY,
  FIRST_NAME     STRING,
  LAST_NAME      STRING,
  GENDER         STRING,
  POSITION       STRING,
  LOCATION       STRING,
  HIRE_DATE      DATE
);

INSERT INTO EMPLOYEE VALUES
(1, 'Anna',    'Ivanenko',  'F', 'HR Manager',      'Kyiv',     '2020-01-15'),
(2, 'Dmytro',  'Petrenko',  'M', 'Recruiter',       'Lviv',     '2019-06-24'),
(3, 'Olha',    'Shevchuk',  'F', 'HR Analyst',      'Dnipro',   '2021-03-10'),
(4, 'Serhiy',  'Kovalchuk', 'M', 'HR Assistant',    'Kyiv',     '2022-05-18'),
(5, 'Kateryna','Polishchuk','F', 'HR Business Partner', 'Lviv', '2020-09-03'),
(6, 'Vitaliy', 'Bondarenko','M', 'HR Manager',      'Dnipro',   '2021-07-22'),
(7, 'Iryna',   'Boyko',     'F', 'Recruiter',       'Kyiv',     '2019-11-01'),
(8, 'Yurii',   'Melnyk',    'M', 'HR Analyst',      'Lviv',     '2022-03-14'),
(9, 'Maria',   'Tkachenko', 'F', 'HR Assistant',    'Dnipro',   '2021-12-07'),
(10,'Oleksandr','Moroz',    'M', 'HR Business Partner', 'Kyiv', '2020-04-27');

CREATE OR REPLACE TABLE HR_EVENT (
  EVENT_ID      INTEGER PRIMARY KEY,
  EMPLOYEE_ID   INTEGER,
  EVENT_TYPE    STRING,
  EVENT_DATE    DATE,
  EVENT_RESULT  STRING
);

INSERT INTO HR_EVENT VALUES
(1, 1, 'Hire',      '2020-01-15', 'Success'),
(2, 2, 'Hire',      '2019-06-24', 'Success'),
(3, 3, 'Hire',      '2021-03-10', 'Success'),
(4, 4, 'Hire',      '2022-05-18', 'Success'),
(5, 5, 'Hire',      '2020-09-03', 'Success'),
(6, 6, 'Hire',      '2021-07-22', 'Success'),
(7, 7, 'Hire',      '2019-11-01', 'Success'),
(8, 8, 'Hire',      '2022-03-14', 'Success'),
(9, 9, 'Hire',      '2021-12-07', 'Success'),
(10,10, 'Hire',     '2020-04-27', 'Success'),
(11, 1, 'Promotion','2021-05-15', 'Promoted'),
(12, 2, 'Leave',    '2021-06-24', 'Returned'),
(13, 3, 'Training', '2022-04-10', 'Completed'),
(14, 4, 'Leave',    '2022-10-03', 'Returned'),
(15, 5, 'Promotion','2021-11-12', 'Promoted'),
(16, 6, 'Training', '2022-02-11', 'Completed'),
(17, 7, 'Leave',    '2020-03-10', 'Returned'),
(18, 8, 'Promotion','2022-07-14', 'Promoted'),
(19, 9, 'Training', '2023-01-20', 'Completed'),
(20,10, 'Leave',    '2021-08-18', 'Returned'),
(21, 1, 'Training', '2022-03-18', 'Completed'),
(22, 2, 'Promotion','2022-11-05', 'Promoted'),
(23, 3, 'Leave',    '2023-05-01', 'Pending'),
(24, 4, 'Training', '2023-02-21', 'Completed'),
(25, 5, 'Promotion','2023-03-28', 'Promoted'),
(26, 6, 'Leave',    '2023-04-13', 'Pending'),
(27, 7, 'Training', '2023-02-10', 'Completed'),
(28, 8, 'Promotion','2023-01-11', 'Promoted'),
(29, 9, 'Leave',    '2023-04-25', 'Pending'),
(30,10,'Training',  '2023-01-29', 'Completed');


----

create schema DEMO.SHARED;
use schema DEMO.SHARED;

CREATE STAGE source_images
  URL = 's3://snowflake-llm-demo/'
  DIRECTORY = ( ENABLE = TRUE )
  ENCRYPTION = ( TYPE = 'AWS_SSE_S3' );

CREATE STAGE my_images
ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE') -- LLM doesn't support client side encryption
DIRECTORY = (ENABLE = TRUE)
COMMENT = 'Stage for storing image files';

COPY FILES INTO @my_images
FROM @source_images;

SET current_user_name = CURRENT_USER();
SET schema_name = 'DEMO.' || $current_user_name;
CREATE SCHEMA IDENTIFIER($schema_name);
