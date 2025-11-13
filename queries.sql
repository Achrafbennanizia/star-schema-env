-- queries.sql

-- 1) Durchschnittstemperatur pro Stadt am 14.11.2025
SELECT l.city, AVG(f.value) AS avg_temperature
FROM
    fact_measurement f
    JOIN dim_location l ON f.location_key = l.location_key
    JOIN dim_measure_type m ON f.measure_type_key = m.measure_type_key
    JOIN dim_time t ON f.time_key = t.time_key
WHERE
    m.name = 'temperature'
    AND t.date = '2025-11-14'
GROUP BY
    l.city
ORDER BY l.city;

-- 2) Zeitreihe: Temperatur in Osnabrück am 14.11.2025
SELECT t.time_of_day, f.value AS temperature_c
FROM
    fact_measurement f
    JOIN dim_location l ON f.location_key = l.location_key
    JOIN dim_measure_type m ON f.measure_type_key = m.measure_type_key
    JOIN dim_time t ON f.time_key = t.time_key
WHERE
    m.name = 'temperature'
    AND l.city = 'Osnabrück'
    AND t.date = '2025-11-14'
ORDER BY t.time_of_day;

-- 3) Welche Mess-Typen wurden je Stadt erfasst?
SELECT DISTINCT
    l.city,
    m.name AS measure_type,
    m.unit
FROM
    fact_measurement f
    JOIN dim_location l ON f.location_key = l.location_key
    JOIN dim_measure_type m ON f.measure_type_key = m.measure_type_key
ORDER BY l.city, m.name;