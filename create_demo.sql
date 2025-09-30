USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE DATABASE SNOWFLAKE_DEMO_DB;

CREATE OR ALTER WAREHOUSE SNOWFLAKE_DEMO_WH
  WAREHOUSE_TYPE = STANDARD
  WAREHOUSE_SIZE = XSMALL
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE;

CREATE OR REPLACE ROLE snowflake_demo_owner;

GRANT ROLE snowflake_demo_owner TO ROLE sysadmin;

GRANT OWNERSHIP ON DATABASE SNOWFLAKE_DEMO_DB TO snowflake_demo_owner;

GRANT USAGE ON WAREHOUSE SNOWFLAKE_DEMO_WH TO ROLE snowflake_demo_owner;

USE ROLE snowflake_demo_owner;

USE DATABASE SNOWFLAKE_DEMO_DB;

CREATE SCHEMA DEMO_TABLES;

USE SCHEMA DEMO_TABLES;

CREATE OR REPLACE TABLE D_COUNTRY
AS SELECT
    seq4() as country_id,
    n_name as country_name,
    r_name as region_name
FROM snowflake_sample_data.tpch_sf1000.nation nation
    inner join snowflake_sample_data.tpch_sf1000.region region on nation.n_regionkey = region.r_regionkey;

CREATE OR REPLACE TABLE D_CUSTOMER
AS SELECT
    SEQ4()                  as client_id,
    'Client ' || SEQ4()     as client_name
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

CREATE OR REPLACE TABLE D_PRODUCT
AS SELECT
    SEQ4()                  as product_id,
    'Product ' || SEQ4()     as product_name
FROM TABLE(GENERATOR(ROWCOUNT => 100));
