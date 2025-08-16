/*
====================================
Create Database and Schemas
====================================
Script Purpose:
	This script creates a new database (DB) labeled, 'DataWarehouse' after checking if it already exists.
	If the DB exists, it is dropped and recreated.
	This script also sets up 3 schemas within the DB: 'bronze', 'silver', 'gold'.

WARNING:
	Running this script will drop the entire 'DataWarehouse' DB if it exists.
	All data in the DB will be permanently deleted. Proceed with caution and ensure 
	you have proper backups before running this script.

*/

USE master;
GO

-- Drop and recreate 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE	DataWarehouse SET SINGLE_USER ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;
GO 

-- Creating 3 schemas
CREATE SCHEMA bronze;
GO -- It is a separator

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
