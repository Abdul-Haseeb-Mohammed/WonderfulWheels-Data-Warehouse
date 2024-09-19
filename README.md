# Wonderful Wheels Data Warehouse Project

Welcome to the Wonderful Wheels Data Warehouse Project! This project is designed to manage and analyze data for Wonderful Wheels, a company specializing in automotive sales. Below is an overview of the key components and their roles.

## Project Overview

The project consists of three primary databases, each serving a unique purpose:

### 1. WonderfulWheels (Operational Database)

**Purpose:** 
- This is the primary operational database where all transactional and daily data is recorded. It handles essential business operations including sales, inventory, customer management, and employee records.

**Key Components:**
- **Customers:** Stores details about customers such as their contact information and registration data.
- **Employees:** Manages employee information including roles, hire dates, and commission structures.
- **Vehicles:** Records information on vehicles, including their make, model, year, and price.
- **Orders and Order Items:** Tracks sales transactions and the items sold.
- **Dealerships:** Contains information about various dealership locations.

### 2. WonderfulWheelsDW (Data Warehouse)

**Purpose:**
- This database is designed for reporting and analytical purposes. It transforms and aggregates data from the operational database into a structured format optimized for querying and analysis.

**Components:**
- **Dimension Tables:**
  - **DimCommissionEmployee:** Details about employees, including their roles and commission structures.
  - **DimCustomer:** Customer information and registration details.
  - **DimVehicle:** Vehicle details such as make, model, and price.
  - **DimDealership:** Information about dealership locations and addresses.
- **Fact Table:**
  - **FactSales:** Captures sales transactions, linking to dimension tables to provide insights into sales performance, including final sale prices and commissions.

### 3. EventLog (Event Logging Database)

**Purpose:**
- This database logs system events and user activities. It is essential for monitoring and troubleshooting the system by recording significant actions and changes.

## Implementation Details

### WonderfulWheels

- This database serves as the source of all operational data and is continuously updated with transactional information. It supports daily business operations and transactions.

### WonderfulWheelsDW

- **ETL Process:** Data is extracted from the WonderfulWheels database, transformed to fit the data warehouse schema, and loaded into WonderfulWheelsDW. This involves creating dimension tables for structured data and a fact table for transactional data.
- **Schema Design:** Utilizes a star schema to simplify complex queries and improve query performance. Dimension tables are linked to the fact table, enabling comprehensive analysis of sales data.

### EventLog

- **Logging Mechanism:** Captures detailed logs of system and user activities. This helps in auditing, monitoring system performance, and diagnosing issues.

## Conclusion

The Wonderful Wheels Data Warehouse Project efficiently organizes operational data into a format conducive to in-depth analysis and reporting. The separation of operational and analytical databases allows for optimized performance and detailed business insights.
