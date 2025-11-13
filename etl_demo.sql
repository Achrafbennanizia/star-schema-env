-- etl_demo.sql
-- 1) Rohdaten in staging_raw_measurements einfügen
INSERT INTO
    staging_raw_measurements (
        ts,
        city,
        country,
        latitude,
        longitude,
        measure_name,
        unit,
        value,
        source
    )
VALUES (
        '2025-11-14 08:00:00',
        'Osnabrück',
        'Germany',
        52.279911,
        8.047179,
        'temperature',
        '°C',
        5.2,
        'iot-gateway-1'
    ),
    (
        '2025-11-14 12:00:00',
        'Osnabrück',
        'Germany',
        52.279911,
        8.047179,
        'temperature',
        '°C',
        8.9,
        'iot-gateway-1'
    ),
    (
        '2025-11-14 12:00:00',
        'Berlin',
        'Germany',
        52.520008,
        13.404954,
        'pm25',
        'µg/m³',
        21.3,
        'iot-gateway-2'
    ),
    (
        '2025-11-14 12:00:00',
        'Osnabrück',
        'Germany',
        52.279911,
        8.047179,
        'humidity',
        '%',
        71.0,
        'iot-gateway-1'
    );

-- 2) Dimension dim_time befüllen (distinct Zeitstempel)
INSERT INTO dim_time (date, time_of_day, year, month, day, weekday_name)
SELECT DISTINCT
    DATE(ts)                          AS date,
    CAST(ts AS TIME)                  AS time_of_day,
    EXTRACT(YEAR  FROM ts)::INT       AS year,
    EXTRACT(MONTH FROM ts)::INT       AS month,
    EXTRACT(DAY   FROM ts)::INT       AS day,
    TO_CHAR(ts, 'Day')                AS weekday_name
FROM staging_raw_measurements s
LEFT JOIN dim_time t
  ON t.date = DATE(s.ts)
 AND t.time_of_day = CAST(s.ts AS TIME)
WHERE t.time_key IS NULL;

-- 3) Dimension dim_location befüllen (distinct Orte)
INSERT INTO
    dim_location (
        city,
        country,
        latitude,
        longitude
    )
SELECT DISTINCT
    s.city,
    s.country,
    s.latitude,
    s.longitude
FROM
    staging_raw_measurements s
    LEFT JOIN dim_location l ON l.city = s.city
    AND l.country = s.country
WHERE
    l.location_key IS NULL;

-- 4) Dimension dim_measure_type befüllen (distinct Typen)
INSERT INTO
    dim_measure_type (name, unit)
SELECT DISTINCT
    s.measure_name,
    s.unit
FROM
    staging_raw_measurements s
    LEFT JOIN dim_measure_type m ON m.name = s.measure_name
    AND m.unit = s.unit
WHERE
    m.measure_type_key IS NULL;

-- 5) Fakten befüllen
INSERT INTO
    fact_measurement (
        time_key,
        location_key,
        measure_type_key,
        value,
        source
    )
SELECT t.time_key, l.location_key, m.measure_type_key, s.value, s.source
FROM
    staging_raw_measurements s
    JOIN dim_time t ON t.date = DATE(s.ts)
    AND t.time_of_day = CAST(s.ts AS TIME)
    JOIN dim_location l ON l.city = s.city
    AND l.country = s.country
    JOIN dim_measure_type m ON m.name = s.measure_name
    AND m.unit = s.unit;