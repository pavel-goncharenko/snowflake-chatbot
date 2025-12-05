SET current_user_name = CURRENT_USER();
SET schema_name = 'DEMO.' || $current_user_name;

use schema IDENTIFIER($schema_name);

-- This complex logic with procedure just to replace schema name in two semantic_views below:
CREATE OR REPLACE PROCEDURE create_agent(schema_name STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION=3.12
ARTIFACT_REPOSITORY = snowflake.snowpark.pypi_shared_repository
PACKAGES=('snowflake-snowpark-python', 'json5')
HANDLER='run'
AS
$$
import json5
def run(session, schema_name):
    spec = {
"models": {
        "orchestration": "auto"
    },
    "orchestration": {},
    "instructions": {
        "response": "Reply short and concise",
        "orchestration": "Use all tools if needed"
    },
    "tools": [
        {
            "tool_spec": {
                "type": "cortex_analyst_text_to_sql",
                "name": "HR",
                "description": "TABLE1: EMPLOYEE\n- Database: DEMO, Schema: HR\n- This table stores comprehensive information about employees within an organization, including their personal details, job information, and employment history. It serves as the central repository for employee data with unique identifiers and demographic information.\n- The table tracks employee locations, positions, and hiring dates, making it essential for HR management and organizational analysis. It provides the foundation for employee-related queries and reporting.\n- LIST OF COLUMNS: EMPLOYEE_ID (unique identifier for each employee), FIRST_NAME (employee's first name), GENDER (employee gender - M or F), LAST_NAME (employee's last name), LOCATION (city where employee is based), POSITION (job title or role), HIRE_DATE (date employee started working)\n\nTABLE2: HR_EVENT\n- Database: DEMO, Schema: HR\n- This table captures various HR-related events and activities for employees, such as training sessions, performance reviews, promotions, and disciplinary actions. Each event is uniquely tracked with specific outcomes and dates.\n- The table maintains a chronological record of employee events, enabling HR departments to track career progression, performance history, and organizational changes. It provides crucial data for employee lifecycle management.\n- LIST OF COLUMNS: EVENT_ID (unique identifier for each HR event), EMPLOYEE_ID (links to employee in EMPLOYEE table), EVENT_RESULT (outcome of the event - Returned/Promoted/Pending), EVENT_TYPE (type of event - Hire/Promotion/Leave), EVENT_DATE (date when event occurred)\n\nREASONING:\nThis semantic view represents a comprehensive HR management system that combines employee master data with their event history. The EMPLOYEE table serves as the central hub containing all employee information, while the HR_EVENT table tracks the dynamic aspects of employee careers through various events. The relationship between these tables through EMPLOYEE_ID creates a complete picture of employee lifecycle management, from hiring to career progression and potential departure.\n\nDESCRIPTION:\nThe HR semantic view provides a complete employee lifecycle management system within the DEMO database's HR schema, combining static employee information with dynamic event tracking. The EMPLOYEE table stores fundamental employee data including personal details, positions, and locations, while the HR_EVENT table captures chronological records of career events such as hires, promotions, and departures. These tables are connected through EMPLOYEE_ID, enabling comprehensive analysis of employee demographics, career progression, and organizational changes. This view supports HR analytics, performance tracking, and workforce management by providing both current employee status and historical event data. The system enables queries about employee distribution, career paths, event outcomes, and temporal analysis of HR activities across the organization."
            }
        },
        {
            "tool_spec": {
                "type": "cortex_analyst_text_to_sql",
                "name": "SALES",
                "description": "DIM_CUSTOMER:\n- Database: DEMO, Schema: SALES\n- This table stores comprehensive customer information including personal details and demographic data to support business analysis and customer segmentation. It serves as the primary customer dimension table with unique identifiers for tracking individual customer records.\n- The table enables customer analysis across different segments (Small Business, Consumer, Corporate) and geographic locations, providing essential data for sales reporting and customer relationship management.\n- LIST OF COLUMNS: CUSTOMER_ID (unique customer identifier - links to CUSTOMER_ID in FACT_SALES_ORDER), FIRST_NAME (customer's first name), LAST_NAME (customer's last name), CITY (customer location city), SEGMENT (customer type classification)\n\nDIM_PRODUCT:\n- Database: DEMO, Schema: SALES\n- This table contains detailed product catalog information including identifiers, names, categories, brands, and pricing data for efficient product tracking and management. It covers three main product categories: Computers, Electronics, and Accessories from various brands.\n- The table supports product analysis by category and brand, enabling inventory management, pricing strategies, and sales performance evaluation across different product lines.\n- LIST OF COLUMNS: PRODUCT_ID (unique product identifier - links to PRODUCT_ID in FACT_ORDER_ITEM), PRODUCT_NAME (name of the product), CATEGORY (product classification), BRAND (manufacturer name), PRICE (product price)\n\nDIM_STORE:\n- Database: DEMO, Schema: SALES\n- This table maintains retail store location information including unique identifiers, names, and geographic details for tracking store-level performance. It provides essential data for analyzing sales across different retail locations.\n- The table enables geographic analysis of store performance across cities and states, supporting location-based business decisions and regional sales comparisons.\n- LIST OF COLUMNS: STORE_ID (unique store identifier - links to STORE_ID in FACT_SALES_ORDER), STORE_NAME (retail store name), CITY (store location city), STATE (store location state abbreviation)\n\nFACT_ORDER_ITEM:\n- Database: DEMO, Schema: SALES\n- This table stores detailed line-item information for each product within an order, capturing quantity, unit pricing, and product details. It represents the granular level of order data showing individual items purchased.\n- The table enables detailed analysis of product sales performance, quantity trends, and pricing variations at the item level within orders.\n- LIST OF COLUMNS: ORDER_ITEM_ID (unique item identifier), ORDER_ID (links to ORDER_ID in FACT_SALES_ORDER), PRODUCT_ID (links to PRODUCT_ID in DIM_PRODUCT), QUANTITY (number of items ordered), UNIT_PRICE (price per individual item)\n\nFACT_SALES_ORDER:\n- Database: DEMO, Schema: SALES\n- This table captures sales order header information including order dates, customer details, store locations, and total order amounts. It serves as the primary fact table for sales transactions and order management.\n- The table enables comprehensive sales analysis by time periods, customers, and store locations, providing key metrics for business performance evaluation and trend analysis.\n- LIST OF COLUMNS: ORDER_ID (unique order identifier - links to ORDER_ID in FACT_ORDER_ITEM), ORDER_DATE (when order was placed), CUSTOMER_ID (links to CUSTOMER_ID in DIM_CUSTOMER), STORE_ID (links to STORE_ID in DIM_STORE), TOTAL_AMOUNT (complete order value)\n\nREASONING:\nThe SALES semantic view represents a comprehensive retail sales data model with interconnected dimension and fact tables. The model follows a star schema design where DIM_CUSTOMER, DIM_PRODUCT, and DIM_STORE serve as dimension tables providing descriptive attributes, while FACT_SALES_ORDER acts as the central fact table capturing sales transactions, and FACT_ORDER_ITEM provides detailed line-item information. The relationships enable analysis across customer segments, product categories, store locations, and time periods, supporting various business intelligence scenarios from customer behavior analysis to product performance evaluation.\n\nDESCRIPTION:\nThe SALES semantic view from the DEMO database provides a complete retail sales analytics framework encompassing customer demographics, product catalog, store locations, and transactional data. The model centers around sales orders with detailed line-item information, connecting customers across different segments (Consumer, Small Business, Corporate) to products spanning Computers, Electronics, and Accessories categories from various brands. Store dimension enables geographic analysis across multiple cities and states, while the fact tables capture both order-level totals and item-level details including quantities and pricing. This integrated view supports comprehensive sales reporting, customer segmentation analysis, product performance evaluation, and store-level comparisons across time periods. The star schema design facilitates efficient querying for business intelligence applications ranging from revenue analysis to inventory management and customer relationship insights."
            }
        }
    ],
    "tool_resources": {
        "HR": {
            "execution_environment": {
                "type": "warehouse",
                "warehouse": ""
            },
            "semantic_view": f"{schema_name}.HR"
        },
        "SALES": {
            "execution_environment": {
                "type": "warehouse",
                "warehouse": ""
            },
            "semantic_view": f"{schema_name}.SALES"
        }
    }
    }

    sql = """
    CREATE OR REPLACE AGENT chatbot
    WITH PROFILE='{"display_name":"Main ChatBot"}'
        COMMENT='Agent'
    FROM SPECIFICATION
    {spec}
    """.replace("{spec}", chr(36)*2 + json5.dumps(spec, indent=3) + chr(36)*2)

    session.sql(sql).collect()
    return sql
$$;

call create_agent($schema_name);

SELECT 'https://app.snowflake.com/_deeplink/#/agents/database/DEMO/schema/' || $current_user_name || '/agent/chatbot/details' as go_to_url;