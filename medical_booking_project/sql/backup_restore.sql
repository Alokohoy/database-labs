-- Medical Booking System - Backup and Restore Strategy
-- Commands should be run from terminal, not in psql

-- BACKUP COMMANDS

-- Full database backup (custom format, compressed)
-- pg_dump -U postgres -d medical_booking_db -F c -Z 9 -f backup_medical_booking_YYYYMMDD.dump

-- Full database backup as SQL script
-- pg_dump -U postgres -d medical_booking_db -f backup_medical_booking_YYYYMMDD.sql

-- Backup only structure (no data)
-- pg_dump -U postgres -d medical_booking_db --schema-only -f backup_schema_only.sql

-- Backup only data (no structure)
-- pg_dump -U postgres -d medical_booking_db --data-only -f backup_data_only.sql

-- RESTORE COMMANDS

-- Restore from custom format dump
-- pg_restore -U postgres -d medical_booking_db -c backup_medical_booking_YYYYMMDD.dump

-- Restore from SQL script
-- psql -U postgres -d medical_booking_db -f backup_medical_booking_YYYYMMDD.sql

-- Restore specific tables only
-- pg_restore -U postgres -d medical_booking_db -t patient -t doctor backup.dump

-- VERIFICATION

-- Check database size
SELECT pg_size_pretty(pg_database_size('medical_booking_db')) AS database_size;

-- Count records in each table (verify after restore)
SELECT 'patient' AS table_name, COUNT(*) FROM patient
UNION ALL SELECT 'doctor', COUNT(*) FROM doctor
UNION ALL SELECT 'appointment', COUNT(*) FROM appointment
UNION ALL SELECT 'payment', COUNT(*) FROM payment;

-- Verify backup file integrity
-- pg_restore --list backup_medical_booking_YYYYMMDD.dump
