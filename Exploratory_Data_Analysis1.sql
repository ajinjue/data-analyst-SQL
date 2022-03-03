/* 
Query #1: Extracting tables and their columns from the sakila schema
*/
SELECT 
	table_name AS tables,
    -- concatenate all the columns of a table
    GROUP_CONCAT(DISTINCT column_name SEPARATOR ',  ') AS column_names
FROM information_schema.columns
WHERE table_schema = 'sakila'
GROUP BY table_name;

/*
Query #2: Store the result of above as a virtual table (VIEW)
*/
CREATE VIEW table_list AS
SELECT 
	table_name AS tables,
    -- concatenate all the columns of a table
    GROUP_CONCAT(DISTINCT column_name SEPARATOR ',  ') AS column_names
FROM information_schema.columns
WHERE table_schema = 'sakila'
GROUP BY table_name;

/* 
Query #3: List the data type of the columns in each table
*/
SELECT 
	table_name,
	column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'sakila'
