-- sample_data.sql
-- Beispiel-Daten für Dimensions-Tabellen (direkt, ohne ETL)

INSERT INTO
    dim_time (
        date,
        time_of_day,
        year,
        month,
        day,
        weekday_name
    )
VALUES (
        '2025-11-14',
        '08:00:00',
        2025,
        11,
        14,
        'Friday'
    ),
    (
        '2025-11-14',
        '12:00:00',
        2025,
        11,
        14,
        'Friday'
    ),
    (
        '2025-11-14',
        '18:00:00',
        2025,
        11,
        14,
        'Friday'
    );

INSERT INTO
    dim_location (
        city,
        country,
        latitude,
        longitude
    )
VALUES (
        'Osnabrück',
        'Germany',
        52.279911,
        8.047179
    ),
    (
        'Berlin',
        'Germany',
        52.520008,
        13.404954
    );

INSERT INTO
    dim_measure_type (name, unit)
VALUES ('temperature', '°C'),
    ('humidity', '%'),
    ('pm25', 'µg/m³');

-- Beispiel-Messungen (Faktentabelle)
-- time_key: 1=08:00, 2=12:00, 3=18:00
-- location_key: 1=Osnabrück, 2=Berlin
-- measure_type_key: 1=temp, 2=hum, 3=pm25

INSERT INTO
    fact_measurement (
        time_key,
        location_key,
        measure_type_key,
        value,
        source
    )
VALUES (1, 1, 1, 5.2, 'sensor-osna-1'), -- 08:00, Osnabrück, Temp
    (2, 1, 1, 8.9, 'sensor-osna-1'), -- 12:00
    (3, 1, 1, 3.5, 'sensor-osna-1'), -- 18:00
    (2, 2, 1, 6.1, 'sensor-ber-1'), -- 12:00, Berlin, Temp
    (
        2,
        1,
        2,
        75.0,
        'sensor-osna-2'
    ), -- 12:00, Osnabrück, Hum
    (2, 2, 3, 21.3, 'sensor-ber-2');
-- 12:00, Berlin, PM2.5