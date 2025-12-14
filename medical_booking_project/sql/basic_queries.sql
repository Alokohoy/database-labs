-- Medical Booking System - Basic SQL Queries 

-- This file contains basic SQL operations: SELECT, INSERT, UPDATE, DELETE

-- SELECT QUERIES

-- 1. Select all patients
SELECT * FROM patient;

-- 2. Select all doctors with their department names (JOIN example)
SELECT 
    d.doctor_id,
    d.first_name || ' ' || d.last_name AS doctor_name,
    d.specialization,
    dept.name AS department_name
FROM doctor d
LEFT JOIN department dept ON d.department_id = dept.department_id;

-- 3. Select appointments with patient and doctor names (multiple JOINs)
SELECT 
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    doc.first_name || ' ' || doc.last_name AS doctor_name,
    a.appointment_date,
    a.start_time,
    a.end_time,
    a.status
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN doctor doc ON a.doctor_id = doc.doctor_id;

-- 4. Select appointments for a specific date (WHERE clause)
SELECT 
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    doc.first_name || ' ' || doc.last_name AS doctor_name,
    a.start_time,
    a.status
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN doctor doc ON a.doctor_id = doc.doctor_id
WHERE a.appointment_date = CURRENT_DATE + INTERVAL '2 days';

-- 5. Count appointments by status (GROUP BY and aggregate function)
SELECT 
    status,
    COUNT(*) AS appointment_count
FROM appointment
GROUP BY status
ORDER BY appointment_count DESC;

-- 6. Select patients older than 30 years (WHERE with function)
SELECT 
    patient_id,
    first_name || ' ' || last_name AS patient_name,
    dob,
    EXTRACT(YEAR FROM AGE(dob)) AS age
FROM patient
WHERE EXTRACT(YEAR FROM AGE(dob)) > 30
ORDER BY age DESC;

 
-- INSERT QUERIES
 

-- 7. Insert a new patient
INSERT INTO patient (first_name, last_name, email, phone, dob, gender, address)
VALUES ('New', 'Patient', 'new.patient@email.com', '+1-555-2001', '1990-01-01', 'Male', '123 New St');

 
-- UPDATE QUERIES


-- 8. Update appointment status
UPDATE appointment
SET status = 'Confirmed',
    updated_at = CURRENT_TIMESTAMP
WHERE appointment_id = 6;

-- 9. Cancel an appointment (UPDATE with string concatenation)
UPDATE appointment
SET status = 'Cancelled',
    notes = COALESCE(notes, '') || ' - Cancelled by patient',
    updated_at = CURRENT_TIMESTAMP
WHERE appointment_id = 7;

 
-- DELETE QUERIES
 

-- 10. Delete a schedule entry
DELETE FROM schedule 
WHERE doctor_id = 1 
  AND day_of_week = 6;
