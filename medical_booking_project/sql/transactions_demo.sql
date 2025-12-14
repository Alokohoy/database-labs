-- Medical Booking System - Transactions Demonstration
-- Demonstrates ACID properties and transaction usage

-- TRANSACTION 1: Booking Appointment with Payment (Atomicity)
-- Ensures both appointment and payment are created together
BEGIN;

INSERT INTO appointment (patient_id, doctor_id, appointment_date, start_time, end_time, status, notes)
VALUES (1, 1, CURRENT_DATE + INTERVAL '20 days', '14:00', '14:30', 'Scheduled', 'New booking');

DO $$
DECLARE
    new_appointment_id INT;
BEGIN
    SELECT MAX(appointment_id) INTO new_appointment_id FROM appointment;
    INSERT INTO payment (appointment_id, amount, method, status)
    VALUES (new_appointment_id, 150.00, 'Credit Card', 'Completed');
END $$;

COMMIT;

-- TRANSACTION 2: Cancelling Appointment with Refund
BEGIN;

UPDATE appointment
SET status = 'Cancelled', notes = COALESCE(notes, '') || ' - Cancelled', updated_at = CURRENT_TIMESTAMP
WHERE appointment_id = 7 AND status IN ('Scheduled', 'Confirmed');

UPDATE payment
SET status = 'Refunded', payment_date = CURRENT_TIMESTAMP
WHERE appointment_id = 7 AND status = 'Completed';

COMMIT;

-- TRANSACTION 3: Demonstrating ROLLBACK on Error
BEGIN;

DO $$
BEGIN
    INSERT INTO appointment (patient_id, doctor_id, appointment_date, start_time, end_time, status)
    VALUES (1, 1, CURRENT_DATE + INTERVAL '30 days', '10:00', '10:30', 'InvalidStatus');
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE;
END $$;

ROLLBACK;
