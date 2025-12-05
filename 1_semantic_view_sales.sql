SET current_user_name = CURRENT_USER();
SET schema_name = 'DEMO.' || $current_user_name;

use schema IDENTIFIER($schema_name);

create or replace semantic view SALES
	tables (
		DEMO.SALES.DIM_CUSTOMER primary key (CUSTOMER_ID) comment='This table stores customer information, including unique identifiers, personal details, and demographic data, to support business analysis and reporting.',
		DEMO.SALES.DIM_PRODUCT primary key (PRODUCT_ID) comment='This table stores information about the products offered by a company, including a unique identifier, product name, category, brand, and price, allowing for efficient tracking and management of product data.',
		DEMO.SALES.DIM_STORE primary key (STORE_ID) comment='This table stores information about retail stores, including a unique identifier, name, city, and state, allowing for the tracking and analysis of store-level data.',
		DEMO.SALES.FACT_ORDER_ITEM primary key (ORDER_ITEM_ID) comment='This table stores detailed information about individual items within an order, including the order and product identifiers, quantity ordered, and unit price of each item.',
		DEMO.SALES.FACT_SALES_ORDER primary key (ORDER_ID) comment='This table stores information about sales orders, including the unique order ID, the date the order was placed, the customer who made the order, the store where the order was made, and the total amount of the order.'
	)
	relationships (
		ITEM_PRODUCT as FACT_ORDER_ITEM(PRODUCT_ID) references DIM_PRODUCT(PRODUCT_ID),
		ITEM_ORDER as FACT_ORDER_ITEM(ORDER_ID) references FACT_SALES_ORDER(ORDER_ID),
		ORDER_CUSTOMER as FACT_SALES_ORDER(CUSTOMER_ID) references DIM_CUSTOMER(CUSTOMER_ID),
		ORDER_STORE as FACT_SALES_ORDER(STORE_ID) references DIM_STORE(STORE_ID)
	)
	facts (
		DIM_PRODUCT.PRICE as PRICE comment='The price of the product.',
		FACT_ORDER_ITEM.QUANTITY as QUANTITY comment='The quantity of items ordered.',
		FACT_ORDER_ITEM.UNIT_PRICE as UNIT_PRICE comment='The price of a single unit of an item in an order.',
		FACT_SALES_ORDER.TOTAL_AMOUNT as TOTAL_AMOUNT comment='The total amount of the sales order, representing the sum of all items sold, including any applicable taxes and discounts.'
	)
	dimensions (
		DIM_CUSTOMER.CITY as CITY comment='The city where the customer is located.',
		DIM_CUSTOMER.CUSTOMER_ID as CUSTOMER_ID comment='Unique identifier for each customer in the database, used to distinguish and track individual customer records.',
		DIM_CUSTOMER.FIRST_NAME as FIRST_NAME comment='The first name of the customer.',
		DIM_CUSTOMER.LAST_NAME as LAST_NAME comment='The customer''s last name.',
		DIM_CUSTOMER.SEGMENT as SEGMENT comment='The type of customer segment, indicating whether the customer is a small business, an individual consumer, or a large corporate entity.',
		DIM_PRODUCT.BRAND as BRAND comment='The brand name of the product, representing the manufacturer or vendor of the product.',
		DIM_PRODUCT.CATEGORY as CATEGORY comment='The category of the product, which can be one of the following: Computers (e.g. laptops, desktops), Electronics (e.g. smartphones, tablets), or Accessories (e.g. keyboards, headphones).',
		DIM_PRODUCT.PRODUCT_ID as PRODUCT_ID comment='Unique identifier for a product in the catalog.',
		DIM_PRODUCT.PRODUCT_NAME as PRODUCT_NAME comment='The name of the product being sold, such as a computer peripheral, computer hardware, or electronic device.',
		DIM_STORE.CITY as CITY comment='The city where the store is located.',
		DIM_STORE.STATE as STATE comment='The two-letter abbreviation for the state in which the store is located.',
		DIM_STORE.STORE_ID as STORE_ID comment='Unique identifier for a retail store location.',
		DIM_STORE.STORE_NAME as STORE_NAME comment='The name of the retail store where a sale was made.',
		FACT_ORDER_ITEM.ORDER_ID as ORDER_ID comment='Unique identifier for each order.',
		FACT_ORDER_ITEM.ORDER_ITEM_ID as ORDER_ITEM_ID comment='Unique identifier for each item within an order.',
		FACT_ORDER_ITEM.PRODUCT_ID as PRODUCT_ID comment='Unique identifier for the product ordered.',
		FACT_SALES_ORDER.CUSTOMER_ID as CUSTOMER_ID comment='Unique identifier for the customer who placed the sales order.',
		FACT_SALES_ORDER.ORDER_DATE as ORDER_DATE comment='The date on which the sales order was placed.',
		FACT_SALES_ORDER.ORDER_ID as ORDER_ID comment='Unique identifier for a sales order.',
		FACT_SALES_ORDER.STORE_ID as STORE_ID comment='Unique identifier for the store where the sales order was placed.'
	)
	with extension (CA='{"tables":[{"name":"DIM_CUSTOMER","dimensions":[{"name":"CITY","sample_values":["Denver","Austin","Seattle"]},{"name":"CUSTOMER_ID","sample_values":["1","2","3"]},{"name":"FIRST_NAME","sample_values":["Alice","Brian","Chloe"]},{"name":"LAST_NAME","sample_values":["Patel","Moreno","Wu"]},{"name":"SEGMENT","sample_values":["Small Business","Consumer","Corporate"]}]},{"name":"DIM_PRODUCT","dimensions":[{"name":"BRAND","sample_values":["Dell","LG","LogiTech"]},{"name":"CATEGORY","sample_values":["Computers","Electronics","Accessories"]},{"name":"PRODUCT_ID","sample_values":["101","102","103"]},{"name":"PRODUCT_NAME","sample_values":["Wireless Mouse","Monitor 27\\"","Laptop 14\\""]}],"facts":[{"name":"PRICE","sample_values":["23.99","219.99","779.00"]}]},{"name":"DIM_STORE","dimensions":[{"name":"CITY","sample_values":["Denver","Austin","Seattle"]},{"name":"STATE","sample_values":["TX","CO","WA"]},{"name":"STORE_ID","sample_values":["12","13","11"]},{"name":"STORE_NAME","sample_values":["Device Hub","Gadget Central","Tech Plaza"]}]},{"name":"FACT_ORDER_ITEM","dimensions":[{"name":"ORDER_ID","sample_values":["1003","1010","1001"]},{"name":"ORDER_ITEM_ID","sample_values":["5003","5001","5002"]},{"name":"PRODUCT_ID","sample_values":["101","102","106"]}],"facts":[{"name":"QUANTITY","sample_values":["2","1"]},{"name":"UNIT_PRICE","sample_values":["129.00","23.99","35.99"]}]},{"name":"FACT_SALES_ORDER","dimensions":[{"name":"CUSTOMER_ID","sample_values":["6","1","3"]},{"name":"ORDER_ID","sample_values":["1003","1010","1001"]},{"name":"STORE_ID","sample_values":["13","11","16"]}],"facts":[{"name":"TOTAL_AMOUNT","sample_values":["23.99","324.97","819.00"]}],"time_dimensions":[{"name":"ORDER_DATE","sample_values":["2023-01-02","2023-01-04","2023-01-05"]}]}],"relationships":[{"name":"ITEM_ORDER"},{"name":"ITEM_PRODUCT"},{"name":"ORDER_CUSTOMER"},{"name":"ORDER_STORE"}]}')
    ;

SELECT 'https://app.snowflake.com/_deeplink/#/cortex/analyst/databases/DEMO/schemas/' || $current_user_name || '/semanticView/SALES/edit' as go_to_url;