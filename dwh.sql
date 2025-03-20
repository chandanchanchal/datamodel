-----------------------------------------DWH---------------------------------------Starts----------------------
What is Data Warehousing?
A Data Warehouse (DWH) is a system used for reporting and data analysis. It integrates data from multiple sources and stores historical data for business intelligence.

🔹 Key Characteristics of a Data Warehouse:
✔ Subject-Oriented – Focuses on a specific business area (e.g., Travel).
✔ Integrated – Combines data from multiple sources.
✔ Time-Variant – Stores historical data.
✔ Non-Volatile – Data is read-only, not updated frequently.

Section 2: Travel Domain Data Warehouse
 Business Case: Travel Data Warehouse
A travel agency wants to analyze:

Bookings & Revenue trends.
Popular travel destinations.
Customer behavior (frequent travelers, spending patterns).
 Data Warehouse Schema Approach
Fact Table: Stores measurable business transactions (e.g., Bookings).
Dimension Tables: Store descriptive data (e.g., Traveler, Destination, Payment).
Schema Types:
Star Schema – Simpler structure with direct relationships.
Snowflake Schema – Normalized structure for better data integrity.

Section 3: Designing the Data Warehouse Schema
 Step 1: Identify Fact & Dimension Tables
Fact Table	                    Measures	                        Granularity (1 row per...)
Fact_Booking	                Total amount, booking count	        Booking ID
