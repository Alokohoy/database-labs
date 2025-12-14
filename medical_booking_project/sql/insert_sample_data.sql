-- ============================================================================
-- Medical Booking System - Sample Data Insertion
-- ============================================================================
-- This script inserts sample data for testing and demonstration purposes
-- ============================================================================

-- Clear existing data (in reverse order of dependencies)
TRUNCATE TABLE payment CASCADE;
TRUNCATE TABLE appointment CASCADE;
TRUNCATE TABLE schedule CASCADE;
TRUNCATE TABLE admin CASCADE;
TRUNCATE TABLE doctor CASCADE;
TRUNCATE TABLE patient CASCADE;
TRUNCATE TABLE department CASCADE;

-- Reset sequences
ALTER SEQUENCE patient_patient_id_seq RESTART WITH 1;
ALTER SEQUENCE department_department_id_seq RESTART WITH 1;
ALTER SEQUENCE doctor_doctor_id_seq RESTART WITH 1;
ALTER SEQUENCE schedule_schedule_id_seq RESTART WITH 1;
ALTER SEQUENCE appointment_appointment_id_seq RESTART WITH 1;
ALTER SEQUENCE payment_payment_id_seq RESTART WITH 1;
ALTER SEQUENCE admin_admin_id_seq RESTART WITH 1;

-- ============================================================================
-- INSERT DEPARTMENTS
-- ============================================================================

INSERT INTO department (name, location, description) VALUES
('Cardiology', 'Building A, Floor 2', 'Heart and cardiovascular system care'),
('Neurology', 'Building A, Floor 3', 'Brain and nervous system disorders'),
('Pediatrics', 'Building B, Floor 1', 'Medical care for infants, children, and adolescents'),
('Orthopedics', 'Building B, Floor 2', 'Bones, joints, and musculoskeletal system'),
('Dermatology', 'Building C, Floor 1', 'Skin, hair, and nail conditions'),
('General Medicine', 'Building A, Floor 1', 'General health and preventive care');

-- ============================================================================
-- INSERT DOCTORS
-- ============================================================================

INSERT INTO doctor (first_name, last_name, specialization, email, phone, department_id, license_number, years_of_experience) VALUES
('John', 'Smith', 'Cardiologist', 'john.smith@hospital.com', '+1-555-0101', 1, 'MD-CARD-001', 15),
('Sarah', 'Johnson', 'Neurologist', 'sarah.johnson@hospital.com', '+1-555-0102', 2, 'MD-NEUR-001', 12),
('Michael', 'Brown', 'Pediatrician', 'michael.brown@hospital.com', '+1-555-0103', 3, 'MD-PED-001', 10),
('Emily', 'Davis', 'Orthopedic Surgeon', 'emily.davis@hospital.com', '+1-555-0104', 4, 'MD-ORTH-001', 8),
('David', 'Wilson', 'Dermatologist', 'david.wilson@hospital.com', '+1-555-0105', 5, 'MD-DERM-001', 14),
('Lisa', 'Anderson', 'General Practitioner', 'lisa.anderson@hospital.com', '+1-555-0106', 6, 'MD-GEN-001', 20),
('Robert', 'Taylor', 'Cardiologist', 'robert.taylor@hospital.com', '+1-555-0107', 1, 'MD-CARD-002', 18),
('Jennifer', 'Martinez', 'Pediatrician', 'jennifer.martinez@hospital.com', '+1-555-0108', 3, 'MD-PED-002', 7);

-- ============================================================================
-- INSERT PATIENTS
-- ============================================================================

INSERT INTO patient (first_name, last_name, email, phone, dob, gender, address) VALUES
('Alice', 'Williams', 'alice.williams@email.com', '+1-555-1001', '1985-03-15', 'Female', '123 Main St, City, State 12345'),
('Bob', 'Jones', 'bob.jones@email.com', '+1-555-1002', '1990-07-22', 'Male', '456 Oak Ave, City, State 12346'),
('Carol', 'Garcia', 'carol.garcia@email.com', '+1-555-1003', '1988-11-30', 'Female', '789 Pine Rd, City, State 12347'),
('Daniel', 'Miller', 'daniel.miller@email.com', '+1-555-1004', '1992-05-18', 'Male', '321 Elm St, City, State 12348'),
('Eva', 'Rodriguez', 'eva.rodriguez@email.com', '+1-555-1005', '1987-09-25', 'Female', '654 Maple Dr, City, State 12349'),
('Frank', 'Lee', 'frank.lee@email.com', '+1-555-1006', '1995-01-12', 'Male', '987 Cedar Ln, City, State 12350'),
('Grace', 'White', 'grace.white@email.com', '+1-555-1007', '1991-12-08', 'Female', '147 Birch Way, City, State 12351'),
('Henry', 'Harris', 'henry.harris@email.com', '+1-555-1008', '1989-04-03', 'Male', '258 Spruce Ct, City, State 12352'),
('Ivy', 'Clark', 'ivy.clark@email.com', '+1-555-1009', '1993-08-19', 'Female', '369 Willow Pl, City, State 12353'),
('Jack', 'Lewis', 'jack.lewis@email.com', '+1-555-1010', '1986-06-27', 'Male', '741 Ash Blvd, City, State 12354');

-- ============================================================================
-- INSERT DOCTOR SCHEDULES
-- ============================================================================

-- Dr. John Smith (Cardiologist) - Monday to Friday, 9 AM to 5 PM
INSERT INTO schedule (doctor_id, day_of_week, start_time, end_time, slot_duration_minutes) VALUES
(1, 1, '09:00', '17:00', 30), -- Monday
(1, 2, '09:00', '17:00', 30), -- Tuesday
(1, 3, '09:00', '17:00', 30), -- Wednesday
(1, 4, '09:00', '17:00', 30), -- Thursday
(1, 5, '09:00', '17:00', 30); -- Friday

-- Dr. Sarah Johnson (Neurologist) - Monday, Wednesday, Friday, 10 AM to 4 PM
INSERT INTO schedule (doctor_id, day_of_week, start_time, end_time, slot_duration_minutes) VALUES
(2, 1, '10:00', '16:00', 45), -- Monday
(2, 3, '10:00', '16:00', 45), -- Wednesday
(2, 5, '10:00', '16:00', 45); -- Friday

-- Dr. Michael Brown (Pediatrician) - Tuesday to Saturday, 8 AM to 6 PM
INSERT INTO schedule (doctor_id, day_of_week, start_time, end_time, slot_duration_minutes) VALUES
(3, 2, '08:00', '18:00', 30), -- Tuesday
(3, 3, '08:00', '18:00', 30), -- Wednesday
(3, 4, '08:00', '18:00', 30), -- Thursday
(3, 5, '08:00', '18:00', 30), -- Friday
(3, 6, '08:00', '14:00', 30); -- Saturday

-- Dr. Emily Davis (Orthopedic) - Monday to Thursday, 9 AM to 3 PM
INSERT INTO schedule (doctor_id, day_of_week, start_time, end_time, slot_duration_minutes) VALUES
(4, 1, '09:00', '15:00', 60), -- Monday
(4, 2, '09:00', '15:00', 60), -- Tuesday
(4, 3, '09:00', '15:00', 60), -- Wednesday
(4, 4, '09:00', '15:00', 60); -- Thursday

-- Dr. David Wilson (Dermatologist) - Monday to Friday, 10 AM to 5 PM
INSERT INTO schedule (doctor_id, day_of_week, start_time, end_time, slot_duration_minutes) VALUES
(5, 1, '10:00', '17:00', 30), -- Monday
(5, 2, '10:00', '17:00', 30), -- Tuesday
(5, 3, '10:00', '17:00', 30), -- Wednesday
(5, 4, '10:00', '17:00', 30), -- Thursday
(5, 5, '10:00', '17:00', 30); -- Friday

-- Dr. Lisa Anderson (General Practitioner) - Monday to Friday, 8 AM to 6 PM
INSERT INTO schedule (doctor_id, day_of_week, start_time, end_time, slot_duration_minutes) VALUES
(6, 1, '08:00', '18:00', 20), -- Monday
(6, 2, '08:00', '18:00', 20), -- Tuesday
(6, 3, '08:00', '18:00', 20), -- Wednesday
(6, 4, '08:00', '18:00', 20), -- Thursday
(6, 5, '08:00', '18:00', 20); -- Friday

-- ============================================================================
-- INSERT APPOINTMENTS
-- ============================================================================

-- Past appointments (completed)
INSERT INTO appointment (patient_id, doctor_id, appointment_date, start_time, end_time, status, notes) VALUES
(1, 1, CURRENT_DATE - INTERVAL '10 days', '10:00', '10:30', 'Completed', 'Regular checkup'),
(2, 2, CURRENT_DATE - INTERVAL '8 days', '11:00', '11:45', 'Completed', 'Headache consultation'),
(3, 3, CURRENT_DATE - INTERVAL '5 days', '14:00', '14:30', 'Completed', 'Child vaccination'),
(4, 4, CURRENT_DATE - INTERVAL '3 days', '10:00', '11:00', 'Completed', 'Knee injury follow-up');

-- Upcoming appointments (scheduled/confirmed)
INSERT INTO appointment (patient_id, doctor_id, appointment_date, start_time, end_time, status, notes) VALUES
(5, 5, CURRENT_DATE + INTERVAL '2 days', '11:00', '11:30', 'Confirmed', 'Skin condition check'),
(6, 6, CURRENT_DATE + INTERVAL '3 days', '09:00', '09:20', 'Scheduled', 'General health check'),
(7, 1, CURRENT_DATE + INTERVAL '5 days', '14:00', '14:30', 'Scheduled', 'Cardiac screening'),
(8, 2, CURRENT_DATE + INTERVAL '7 days', '13:00', '13:45', 'Confirmed', 'Neurological exam'),
(9, 3, CURRENT_DATE + INTERVAL '10 days', '10:00', '10:30', 'Scheduled', 'Pediatric consultation'),
(10, 4, CURRENT_DATE + INTERVAL '12 days', '11:00', '12:00', 'Scheduled', 'Back pain evaluation');

-- Cancelled appointment
INSERT INTO appointment (patient_id, doctor_id, appointment_date, start_time, end_time, status, notes) VALUES
(1, 6, CURRENT_DATE - INTERVAL '2 days', '15:00', '15:20', 'Cancelled', 'Patient requested cancellation');

-- ============================================================================
-- INSERT PAYMENTS
-- ============================================================================

-- Payments for completed appointments
INSERT INTO payment (appointment_id, amount, payment_date, method, status) VALUES
(1, 150.00, CURRENT_DATE - INTERVAL '10 days', 'Credit Card', 'Completed'),
(2, 200.00, CURRENT_DATE - INTERVAL '8 days', 'Online', 'Completed'),
(3, 100.00, CURRENT_DATE - INTERVAL '5 days', 'Cash', 'Completed'),
(4, 300.00, CURRENT_DATE - INTERVAL '3 days', 'Insurance', 'Completed');

-- Payment for confirmed upcoming appointment
INSERT INTO payment (appointment_id, amount, payment_date, method, status) VALUES
(5, 120.00, CURRENT_DATE, 'Online', 'Completed'),
(8, 200.00, CURRENT_DATE, 'Credit Card', 'Completed');

-- ============================================================================
-- INSERT ADMIN USERS
-- ============================================================================

-- Note: In production, passwords should be properly hashed (e.g., using bcrypt)
-- These are example hashes (not real passwords)
INSERT INTO admin (username, password_hash, email, full_name, role) VALUES
('admin', '$2a$10$example_hash_here', 'admin@hospital.com', 'System Administrator', 'Admin'),
('manager', '$2a$10$example_hash_here', 'manager@hospital.com', 'Hospital Manager', 'Manager');

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Display summary of inserted data
SELECT 'Departments' as table_name, COUNT(*) as count FROM department
UNION ALL
SELECT 'Doctors', COUNT(*) FROM doctor
UNION ALL
SELECT 'Patients', COUNT(*) FROM patient
UNION ALL
SELECT 'Schedules', COUNT(*) FROM schedule
UNION ALL
SELECT 'Appointments', COUNT(*) FROM appointment
UNION ALL
SELECT 'Payments', COUNT(*) FROM payment
UNION ALL
SELECT 'Admins', COUNT(*) FROM admin;


