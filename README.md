# Mini Star Schema: Umweltmessdaten (Zeit, Ort, Typ, Wert)

Beispiel eines einfachen **Star-Schemas** zur Speicherung von Umweltmessdaten
(z. B. Temperatur, Luftfeuchtigkeit, Feinstaub) mit den Dimensionen **Zeit**,
**Ort** und **Mess-Typ** sowie einer Faktentabelle mit dem Messwert.

Das Projekt zeigt:

- Grundstruktur eines Data Warehouse Star-Schemas
- Trennung von Dimensionen und Faktentabelle
- Einfaches ETL-Beispiel von einer Staging-Tabelle in das Star-Schema
- Typische Analyse-Queries (AVG, GROUP BY, Zeitreihen)

## Schema-Übersicht

**Dimensionen**

- `dim_time(time_key, date, time_of_day, year, month, day, weekday_name)`
- `dim_location(location_key, city, country, latitude, longitude)`
- `dim_measure_type(measure_type_key, name, unit)`

**Faktentabelle**

- `fact_measurement(measurement_id, time_key, location_key, measure_type_key, value, source, created_at)`

Zusätzlich gibt es eine Staging-Tabelle:

- `staging_raw_measurements(...)` für das ETL-Demo.

## Tech-Stack

- SQL
- PostgreSQL (getestet mit Version XY)
- (Optional) leicht anpassbar für SQLite

## Nutzung

### 1. Datenbank erstellen

```bash
createdb star_schema_env
psql -d star_schema_env -f schema.sql
```
### 2. Demo-Daten einspielen
Variante A: direkte Dimension + Fakten (schnell, zum Testen):
```bash
psql -d star_schema_env -f sample_data.sql
```
Variante B: ETL-Demo über Staging:
```bash
psql -d star_schema_env -f etl_demo.sql
```
### 3. Beispiel-Queries ausführen
```bash
psql -d star_schema_env -f queries.sql
```
Oder interaktiv:
```bash
psql -d star_schema_env
-- dann z. B.:
-- \i queries.sql
```

### Lernziele

- Verständnis von Dimensionstabellen und Faktentabellen
- Aufbau eines einfachen Star-Schemas
- Grundidee von ETL (Extract–Transform–Load) mit Staging-Tabelle
- Schreiben von analytischen SQL-Queries auf einem Star-Schema
