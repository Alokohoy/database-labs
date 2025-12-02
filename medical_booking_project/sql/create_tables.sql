CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- PATIENT
CREATE TABLE patient (
  patient_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(150) UNIQUE,
  phone VARCHAR(30),
  dob DATE,
  gender VARCHAR(10),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- DEPARTMENT
CREATE TABLE department (
  department_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  location VARCHAR(200)
);

-- DOCTOR
CREATE TABLE doctor (
  doctor_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  specialization VARCHAR(100),
  email VARCHAR(150) UNIQUE,
  phone VARCHAR(30),
  department_id INT REFERENCES department(department_id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- SCHEDULE (описание шаблона доступности)
CREATE TABLE schedule (
  schedule_id SERIAL PRIMARY KEY,
  doctor_id INT REFERENCES doctor(doctor_id) ON DELETE CASCADE,
  day_of_week SMALLINT NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  slot_duration_minutes INT NOT NULL DEFAULT 30,
  CHECK (start_time < end_time)
);

-- APPOINTMENT
CREATE TABLE appointment (
  appointment_id SERIAL PRIMARY KEY,
  patient_id INT REFERENCES patient(patient_id) ON DELETE CASCADE,
  doctor_id INT REFERENCES doctor(doctor_id) ON DELETE CASCADE,
  appointment_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  CHECK (start_time < end_time)
);


CREATE UNIQUE INDEX ux_doctor_date_start ON appointment (doctor_id, appointment_date, start_time);

-- PAYMENT 
CREATE TABLE payment (
  payment_id SERIAL PRIMARY KEY,
  appointment_id INT REFERENCES appointment(appointment_id) ON DELETE CASCADE,
  amount NUMERIC(10,2) NOT NULL,
  payment_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  method VARCHAR(50)
);

-- ADMIN
CREATE TABLE admin (
  admin_id SERIAL PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL
);
