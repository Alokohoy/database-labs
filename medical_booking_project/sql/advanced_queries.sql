-- Medical Booking System - Advanced SQL Queries
-- This file contains 3 advanced SQL queries demonstrating complex operations

-- QUERY 1: Complex JOIN with Multiple Tables and Aggregations

-- Demonstrates: INNER JOIN, LEFT JOIN, aggregate functions, CASE statements
-- Purpose: Get complete appointment details with patient, doctor, department, and payment info

SELECT 
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.email AS patient_email,
    doc.first_name || ' ' || doc.last_name AS doctor_name,
    doc.specialization,
    dept.name AS department_name,
    a.appointment_date,
    a.start_time,
    a.end_time,
    a.status AS appointment_status,
    CASE 
        WHEN pay.payment_id IS NOT NULL THEN 'Paid'
        ELSE 'Unpaid'
    END AS payment_status,
    COALESCE(pay.amount, 0) AS payment_amount,
    pay.method AS payment_method
FROM appointment a
INNER JOIN patient p ON a.patient_id = p.patient_id
INNER JOIN doctor doc ON a.doctor_id = doc.doctor_id
LEFT JOIN department dept ON doc.department_id = dept.department_id
LEFT JOIN payment pay ON a.appointment_id = pay.appointment_id
ORDER BY a.appointment_date, a.start_time;

-- QUERY 2: Subquery with Aggregate Functions
-- Demonstrates: Subqueries, HAVING clause, aggregate functions
-- Purpose: Find doctors who have more appointments than the average

SELECT 
    d.doctor_id,
    d.first_name || ' ' || d.last_name AS doctor_name,
    d.specialization,
    COUNT(a.appointment_id) AS appointment_count
FROM doctor d
JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialization
HAVING COUNT(a.appointment_id) > (
    SELECT AVG(appt_count)
    FROM (
        SELECT COUNT(*) AS appt_count
        FROM appointment
        GROUP BY doctor_id
    ) AS avg_counts
)
ORDER BY appointment_count DESC;

-- QUERY 3: Common Table Expression (CTE) with Window Functions
-- Demonstrates: CTE, window functions (RANK, PERCENT_RANK), aggregate functions
-- Purpose: Patient ranking by total spending with percentile analysis

WITH patient_spending AS (
    SELECT 
        p.patient_id,
        p.first_name || ' ' || p.last_name AS patient_name,
        COUNT(DISTINCT a.appointment_id) AS total_appointments,
        SUM(pay.amount) AS total_spent
    FROM patient p
    JOIN appointment a ON p.patient_id = a.patient_id
    JOIN payment pay ON a.appointment_id = pay.appointment_id
    WHERE pay.status = 'Completed'
    GROUP BY p.patient_id, p.first_name, p.last_name
)
SELECT 
    patient_id,
    patient_name,
    total_appointments,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank,
    PERCENT_RANK() OVER (ORDER BY total_spent DESC) AS spending_percentile
FROM patient_spending
ORDER BY total_spent DESC;
