-- Medical Booking System - Indexing Demonstration

-- CREATE ADDITIONAL INDEXES

-- 1. Composite index for appointment queries (multiple columns)
CREATE INDEX IF NOT EXISTS idx_appointment_doctor_date_status 
ON appointment(doctor_id, appointment_date, status)
WHERE status IN ('Scheduled', 'Confirmed');

-- 2. Partial index for active appointments only (filters data)
CREATE INDEX IF NOT EXISTS idx_appointment_active 
ON appointment(appointment_date, start_time)
WHERE status IN ('Scheduled', 'Confirmed') AND appointment_date >= CURRENT_DATE;

-- 3. Expression index for age calculations
CREATE INDEX IF NOT EXISTS idx_patient_age 
ON patient(EXTRACT(YEAR FROM AGE(dob)));

-- VIEW ALL INDEXES
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- DEMONSTRATE INDEX EFFECTIVENESS
-- EXPLAIN ANALYZE shows how PostgreSQL executes the query

-- Query using index (fast - Index Scan)
EXPLAIN ANALYZE
SELECT * FROM patient
WHERE email = 'alice.williams@email.com';

-- Query using composite index (fast - Index Scan)
EXPLAIN ANALYZE
SELECT appointment_id, appointment_date, start_time, status
FROM appointment
WHERE doctor_id = 1 
  AND appointment_date >= CURRENT_DATE
  AND status = 'Scheduled';

-- UPDATE STATISTICS (helps query planner choose best index)
ANALYZE patient;
ANALYZE appointment;
