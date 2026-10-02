/*
================================================================================
METADATA:
  Document_Title: Clinical Patient Encounters & Electronic Health Records (EHR)
  Database_Dialect: ANSI SQL / SQLite / PostgreSQL
  Schema_Version: 1.8.2
  Author: Joshua Asemani
  Department: Health Informatics & Medical AI
  Data_Classification: HIPAA Compliant / Synthetic Anonymized
  Created_At: 2026-10-02
  Tags: [healthcare, ehr, clinical-trials, diagnostics, hipaa, rag-benchmark]
  Description: >
    Clinical data model simulating electronic medical records. Includes patient admission
    demographics, vital signs telemetry, ICD-10 diagnostic codes, and laboratory test
    observations formatted for semantic search and clinical question answering.
================================================================================
*/

CREATE TABLE IF NOT EXISTS clinical_patients (
    patient_uuid VARCHAR(36) PRIMARY KEY,
    anonymized_mrn VARCHAR(20) UNIQUE NOT NULL,
    age_years INTEGER NOT NULL,
    gender VARCHAR(10) NOT NULL,
    blood_group VARCHAR(5) NOT NULL,
    chronic_conditions TEXT, -- Comma-delimited list of diagnosed chronic diseases
    primary_physician VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS patient_encounters (
    encounter_id VARCHAR(36) PRIMARY KEY,
    patient_uuid VARCHAR(36) REFERENCES clinical_patients(patient_uuid),
    admission_type VARCHAR(20) NOT NULL, -- [Emergency, Elective, Urgent, Observation]
    systolic_bp INTEGER NOT NULL,
    diastolic_bp INTEGER NOT NULL,
    heart_rate_bpm INTEGER NOT NULL,
    primary_icd10_code VARCHAR(10) NOT NULL,
    diagnostic_summary TEXT NOT NULL,
    admission_date DATE NOT NULL,
    discharge_date DATE
);

INSERT INTO clinical_patients (patient_uuid, anonymized_mrn, age_years, gender, blood_group, chronic_conditions, primary_physician)
VALUES
    ('PAT-4401', 'MRN-78901', 58, 'Female', 'A+', 'Type 2 Diabetes, Hypertension', 'Dr. Rachel Adams, MD'),
    ('PAT-4402', 'MRN-78902', 42, 'Male', 'O-', 'Asthma', 'Dr. Vikram Patel, MD'),
    ('PAT-4403', 'MRN-78903', 67, 'Male', 'B+', 'Coronary Artery Disease, Hyperlipidemia', 'Dr. Rachel Adams, MD');

INSERT INTO patient_encounters (encounter_id, patient_uuid, admission_type, systolic_bp, diastolic_bp, heart_rate_bpm, primary_icd10_code, diagnostic_summary, admission_date, discharge_date)
VALUES
    ('ENC-101', 'PAT-4401', 'Emergency', 158, 96, 92, 'I10', 'Hypertensive crisis managed with intravenous labetalol. Vitals stabilized within 6 hours.', '2026-08-14', '2026-08-16'),
    ('ENC-102', 'PAT-4402', 'Urgent', 122, 78, 105, 'J45.901', 'Acute exacerbation of moderate persistent asthma triggered by seasonal allergens. Administered nebulized albuterol.', '2026-09-02', '2026-09-03'),
    ('ENC-103', 'PAT-4403', 'Elective', 134, 84, 68, 'I25.10', 'Scheduled coronary angiography and drug-eluting stent placement in proximal LAD. Procedure uneventful.', '2026-09-20', '2026-09-22');
