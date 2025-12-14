-- Medical Booking System - Database Schema

-- This script creates all tables for the Medical Appointment Booking System
-- Database: PostgreSQL
-- Normalization: 3NF (Third Normal Form)

-- Enable UUID extension (if needed for future enhancements)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
 
-- CORE TABLES

-- PATIENT TABLE
-- Stores patient information

CREATE TABLE patient (
  patient_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  phone VARCHAR(30) NOT NULL,
  dob DATE NOT NULL,
  gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
  address VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- DEPARTMENT TABLE
-- Stores hospital/clinic departments
CREATE TABLE department (
  department_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  location VARCHAR(200),
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- DOCTOR TABLE
-- Stores doctor information
CREATE TABLE doctor (
  doctor_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  specialization VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  phone VARCHAR(30) NOT NULL,
  department_id INT REFERENCES department(department_id) ON DELETE SET NULL,
  license_number VARCHAR(50) UNIQUE,
  years_of_experience INT CHECK (years_of_experience >= 0),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- SCHEDULE TABLE
-- Stores doctor availability schedule templates
CREATE TABLE schedule (
  schedule_id SERIAL PRIMARY KEY,
  doctor_id INT NOT NULL REFERENCES doctor(doctor_id) ON DELETE CASCADE,
  day_of_week SMALLINT NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
  -- 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  slot_duration_minutes INT NOT NULL DEFAULT 30 CHECK (slot_duration_minutes > 0),
  is_available BOOLEAN DEFAULT TRUE,
  CHECK (start_time < end_time),
  UNIQUE(doctor_id, day_of_week, start_time)
);

-- APPOINTMENT TABLE
-- Stores appointment bookings
CREATE TABLE appointment (
  appointment_id SERIAL PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES patient(patient_id) ON DELETE CASCADE,
  doctor_id INT NOT NULL REFERENCES doctor(doctor_id) ON DELETE CASCADE,
  appointment_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'Scheduled' 
    CHECK (status IN ('Scheduled', 'Confirmed', 'Completed', 'Cancelled', 'No-Show')),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CHECK (start_time < end_time),
  CHECK (appointment_date >= CURRENT_DATE)
);

-- Create unique index to prevent double booking
CREATE UNIQUE INDEX ux_doctor_date_start ON appointment (doctor_id, appointment_date, start_time)
WHERE status IN ('Scheduled', 'Confirmed');

-- PAYMENT TABLE
-- Stores payment information for appointments
CREATE TABLE payment (
  payment_id SERIAL PRIMARY KEY,
  appointment_id INT NOT NULL REFERENCES appointment(appointment_id) ON DELETE CASCADE,
  amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
  payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  method VARCHAR(50) CHECK (method IN ('Cash', 'Credit Card', 'Debit Card', 'Online', 'Insurance')),
  transaction_id VARCHAR(100),
  status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Completed', 'Failed', 'Refunded'))
);

-- ADMIN TABLE
-- Stores system administrator accounts
CREATE TABLE admin (
  admin_id SERIAL PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  full_name VARCHAR(100),
  role VARCHAR(50) DEFAULT 'Admin',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP WITH TIME ZONE
);

-- INDEXES FOR PERFORMANCE

-- Indexes on foreign keys for faster joins
CREATE INDEX idx_doctor_department ON doctor(department_id);
CREATE INDEX idx_schedule_doctor ON schedule(doctor_id);
CREATE INDEX idx_appointment_patient ON appointment(patient_id);
CREATE INDEX idx_appointment_doctor ON appointment(doctor_id);
CREATE INDEX idx_appointment_date ON appointment(appointment_date);
CREATE INDEX idx_appointment_status ON appointment(status);
CREATE INDEX idx_payment_appointment ON payment(appointment_id);

-- Indexes for common query patterns
CREATE INDEX idx_patient_email ON patient(email);
CREATE INDEX idx_doctor_email ON doctor(email);
CREATE INDEX idx_doctor_specialization ON doctor(specialization);

-- TRIGGERS FOR AUTOMATIC UPDATES

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to tables with updated_at column
CREATE TRIGGER update_patient_updated_at BEFORE UPDATE ON patient
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_doctor_updated_at BEFORE UPDATE ON doctor
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_appointment_updated_at BEFORE UPDATE ON appointment
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 
-- COMMENTS FOR DOCUMENTATION
-- 

COMMENT ON TABLE patient IS 'Stores patient personal and contact information';
COMMENT ON TABLE department IS 'Stores hospital/clinic department information';
COMMENT ON TABLE doctor IS 'Stores doctor information and their department association';
COMMENT ON TABLE schedule IS 'Stores doctor availability schedule templates by day of week';
COMMENT ON TABLE appointment IS 'Stores appointment bookings between patients and doctors';
COMMENT ON TABLE payment IS 'Stores payment transactions for appointments';
COMMENT ON TABLE admin IS 'Stores system administrator account information';
