-- schema.sql
-- Star-Schema für Umweltmessdaten (Ort, Zeit, Typ, Wert)

DROP TABLE IF EXISTS fact_measurement CASCADE;

DROP TABLE IF EXISTS dim_time CASCADE;

DROP TABLE IF EXISTS dim_location CASCADE;

DROP TABLE IF EXISTS dim_measure_type CASCADE;

DROP TABLE IF EXISTS staging_raw_measurements CASCADE;

-- Dimension: Zeit
CREATE TABLE dim_time (
    time_key SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    time_of_day TIME NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    weekday_name VARCHAR(20) NOT NULL
);

-- Dimension: Ort
CREATE TABLE dim_location (
    location_key SERIAL PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    latitude NUMERIC(9, 6),
    longitude NUMERIC(9, 6)
);

-- Dimension: Mess-Typ (z.B. Temperatur, Luftfeuchtigkeit, PM2.5)
CREATE TABLE dim_measure_type (
    measure_type_key SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    unit VARCHAR(20) NOT NULL
);

-- Faktentabelle: Messung
CREATE TABLE fact_measurement (
    measurement_id SERIAL PRIMARY KEY,
    time_key INT NOT NULL REFERENCES dim_time (time_key),
    location_key INT NOT NULL REFERENCES dim_location (location_key),
    measure_type_key INT NOT NULL REFERENCES dim_measure_type (measure_type_key),
    value NUMERIC(10, 3) NOT NULL,
    source VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Staging-Tabelle für ETL-Demo
CREATE TABLE staging_raw_measurements (
    id SERIAL PRIMARY KEY,
    ts TIMESTAMP NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    latitude NUMERIC(9, 6),
    longitude NUMERIC(9, 6),
    measure_name VARCHAR(50) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    value NUMERIC(10, 3) NOT NULL,
    source VARCHAR(100)
);