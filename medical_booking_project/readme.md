# Medical Appointment Booking System

Final database project for AUCA Database Course. A complete PostgreSQL database system for managing medical appointments, doctors, patients, and payments.

 What's Included

- Database Schema: 7 normalized tables (3NF) with proper relationships
- SQL Queries: Basic and advanced examples
- Transactions: ACID properties demonstration
- Indexing: Performance optimization examples
- Backup Strategy: Database backup and restore procedures

 Quick Start

1. Install PostgreSQL

macOS:
```bash
brew install postgresql
brew services start postgresql
```

Linux:
```bash
sudo apt-get install postgresql postgresql-contrib
sudo systemctl start postgresql
```


2. Create Database

```bash
psql -U postgres
CREATE DATABASE medical_booking_db;
\c medical_booking_db
```

3. Run Scripts

```bash
# Create tables
psql -U postgres -d medical_booking_db -f sql/create_tables.sql

# Insert sample data
psql -U postgres -d medical_booking_db -f sql/insert_sample_data.sql

# Verify
psql -U postgres -d medical_booking_db -c "SELECT COUNT(*) FROM patient;"
```

 Database Structure

Tables:
- `patient` - Patient information
- `department` - Hospital departments
- `doctor` - Doctor details and specializations
- `schedule` - Doctor availability
- `appointment` - Appointment bookings
- `payment` - Payment records
- `admin` - Administrator accounts

Key Features:
- Foreign keys for data integrity
- Check constraints for validation
- Indexes for performance
- Triggers for automatic updates
- Unique constraints to prevent double booking

 SQL Files

- `create_tables.sql` - Creates all tables, indexes, and triggers
- `insert_sample_data.sql` - Sample data (6 departments, 8 doctors, 10 patients)
- `basic_queries.sql` - Basic SELECT, INSERT, UPDATE, DELETE examples
- `advanced_queries.sql` - Complex JOINs, subqueries, CTEs, window functions
- `transactions_demo.sql` - Transaction examples with ACID properties
- `indexing_demo.sql` - Index creation and performance analysis
- `backup_restore.sql` - Backup and restore commands

 Example Queries

```sql
-- View all appointments
SELECT * FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN doctor d ON a.doctor_id = d.doctor_id;

-- Find doctors by department
SELECT d.first_name || ' ' || d.last_name AS doctor_name, dept.name
FROM doctor d
JOIN department dept ON d.department_id = dept.department_id;
```

 Project Requirements

ER-diagram and normalized schema   
PostgreSQL implementation  
Basic and advanced SQL queries  
Transactions demonstration  
Indexing demonstration  
Backup and restore strategy  

 Notes

Educational project for AUCA Database Course.
