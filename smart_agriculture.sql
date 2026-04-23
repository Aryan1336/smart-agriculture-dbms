-- smart agriculture sensor 

CREATE DATABASE smart_agriculture;
\c smart_agriculture;

-- farmers table 
CREATE TABLE farmers (
    farmer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- farms 
CREATE TABLE farms (
    farm_id SERIAL PRIMARY KEY,
    farmer_id INT REFERENCES farmers(farmer_id) ON DELETE CASCADE,
    farm_name VARCHAR(100),
    location VARCHAR(200),
    area_hectares DECIMAL(10,2),
    soil_type VARCHAR(50),
    crop_type VARCHAR(100)
);

-- the sensor types
CREATE TABLE sensor_types (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    unit VARCHAR(20),
    description TEXT
);

-- actual sensors
CREATE TABLE sensors (
    sensor_id SERIAL PRIMARY KEY,
    farm_id INT REFERENCES farms(farm_id) ON DELETE CASCADE,
    type_id INT REFERENCES sensor_types(type_id),
    model_name VARCHAR(100),
    manufacturer VARCHAR(100),
    installation_date DATE,
    status VARCHAR(20) DEFAULT 'active',
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

-- sensor readings 
CREATE TABLE sensor_readings (
    reading_id SERIAL PRIMARY KEY,
    sensor_id INT REFERENCES sensors(sensor_id) ON DELETE CASCADE,
    reading_value DECIMAL(10,2) NOT NULL,
    reading_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- alerts
CREATE TABLE alerts (
    alert_id SERIAL PRIMARY KEY,
    sensor_id INT REFERENCES sensors(sensor_id) ON DELETE CASCADE,
    alert_type VARCHAR(50),
    severity VARCHAR(20) CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    message TEXT,
    is_resolved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

-- threshold configs 
CREATE TABLE thresholds (
    threshold_id SERIAL PRIMARY KEY,
    sensor_id INT REFERENCES sensors(sensor_id) ON DELETE CASCADE,
    min_value DECIMAL(10,2),
    max_value DECIMAL(10,2),
    alert_enabled BOOLEAN DEFAULT TRUE
);

-- irrigation stuff
CREATE TABLE irrigation_systems (
    irrigation_id SERIAL PRIMARY KEY,
    farm_id INT REFERENCES farms(farm_id) ON DELETE CASCADE,
    system_type VARCHAR(50),
    status VARCHAR(20) DEFAULT 'off',
    last_activated TIMESTAMP,
    water_usage_liters DECIMAL(10,2)
);

-- logs for irrigation actions
CREATE TABLE irrigation_logs (
    log_id SERIAL PRIMARY KEY,
    irrigation_id INT REFERENCES irrigation_systems(irrigation_id) ON DELETE CASCADE,
    sensor_id INT REFERENCES sensors(sensor_id),
    action VARCHAR(20) CHECK (action IN ('on', 'off', 'auto')),
    triggered_by VARCHAR(30) DEFAULT 'manual',
    duration_minutes INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- crop health
CREATE TABLE crop_health (
    health_id SERIAL PRIMARY KEY,
    farm_id INT REFERENCES farms(farm_id) ON DELETE CASCADE,
    assessment_date DATE,
    health_status VARCHAR(30) CHECK (health_status IN ('healthy', 'moderate', 'poor', 'dead')),
    pest_detected BOOLEAN DEFAULT FALSE,
    disease_detected BOOLEAN DEFAULT FALSE,
    notes TEXT
);

-- weather data
CREATE TABLE weather_data (
    weather_id SERIAL PRIMARY KEY,
    farm_id INT REFERENCES farms(farm_id) ON DELETE CASCADE,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    rainfall_mm DECIMAL(7,2),
    wind_speed DECIMAL(5,2),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Data

INSERT INTO farmers (name, phone, email, address) VALUES
('Ramesh Kumar', '9876543210', 'ramesh@gmail.com', 'Village Kothur, Telangana'),
('Sita Devi', '8765432109', 'sita.devi@yahoo.com', 'Amravati, Maharashtra'),
('Arjun Patel', '7654321098', 'arjun.p@hotmail.com', 'Anand, Gujarat'),
('Lakshmi Bai', '6543210987', 'lakshmi.b@gmail.com', 'Warangal, Telangana'),
('Ravi Shankar', '9988776655', 'ravi.s@gmail.com', 'Mysore, Karnataka');

INSERT INTO farms (farmer_id, farm_name, location, area_hectares, soil_type, crop_type) VALUES
(1, 'Green Acres', 'Kothur, Telangana', 5.50, 'Black Soil', 'Rice'),
(1, 'Sunrise Fields', 'Medak, Telangana', 3.20, 'Red Soil', 'Cotton'),
(2, 'Mango Grove', 'Amravati, Maharashtra', 8.00, 'Alluvial', 'Wheat'),
(3, 'Patel Farm', 'Anand, Gujarat', 12.00, 'Sandy Loam', 'Groundnut'),
(4, 'Lakshmi Fields', 'Warangal, Telangana', 6.75, 'Black Soil', 'Sugarcane'),
(5, 'Karnataka Greens', 'Mysore, Karnataka', 4.00, 'Laterite', 'Coffee');

INSERT INTO sensor_types (type_name, unit, description) VALUES
('Soil Moisture', '%', 'Measures moisture content in soil'),
('Temperature', '°C', 'Measures ambient temperature'),
('Humidity', '%', 'Measures air humidity level'),
('pH Sensor', 'pH', 'Measures soil pH level'),
('Light Intensity', 'Lux', 'Measures sunlight intensity'),
('Rainfall', 'mm', 'Measures rainfall amount'),
('Wind Speed', 'km/h', 'Measures wind speed'),
('Soil NPK', 'mg/kg', 'Measures nitrogen phosphorus potassium');

INSERT INTO sensors (farm_id, type_id, model_name, manufacturer, installation_date, status, latitude, longitude) VALUES
(1, 1, 'SM-400X', 'AgriTech', '2025-01-15', 'active', 17.3850, 78.4867),
(1, 2, 'TMP-200', 'SensorCorp', '2025-01-15', 'active', 17.3851, 78.4868),
(1, 3, 'HUM-300', 'SensorCorp', '2025-02-01', 'active', 17.3852, 78.4869),
(2, 1, 'SM-400X', 'AgriTech', '2025-03-10', 'active', 17.6200, 78.1400),
(2, 4, 'PH-100', 'GroundSense', '2025-03-10', 'active', 17.6201, 78.1401),
(3, 1, 'SM-500Pro', 'AgriTech', '2025-02-20', 'active', 20.9320, 77.7523),
(3, 2, 'TMP-200', 'SensorCorp', '2025-02-20', 'inactive', 20.9321, 77.7524),
(4, 1, 'SM-400X', 'AgriTech', '2025-04-01', 'active', 22.5645, 72.9289),
(4, 5, 'LUX-700', 'BrightSense', '2025-04-01', 'active', 22.5646, 72.9290),
(5, 1, 'SM-500Pro', 'AgriTech', '2025-05-15', 'active', 18.0000, 79.5800),
(5, 6, 'RAIN-50', 'WeatherNode', '2025-05-15', 'active', 18.0001, 79.5801),
(6, 2, 'TMP-200', 'SensorCorp', '2025-06-01', 'active', 12.2958, 76.6394),
(6, 8, 'NPK-900', 'GroundSense', '2025-06-01', 'active', 12.2959, 76.6395);

INSERT INTO sensor_readings (sensor_id, reading_value, reading_time) VALUES
(1, 42.50, '2025-08-01 06:00:00'),
(1, 38.20, '2025-08-01 12:00:00'),
(1, 45.10, '2025-08-01 18:00:00'),
(2, 32.50, '2025-08-01 06:00:00'),
(2, 38.00, '2025-08-01 12:00:00'),
(2, 29.80, '2025-08-01 18:00:00'),
(3, 78.00, '2025-08-01 06:00:00'),
(3, 65.30, '2025-08-01 12:00:00'),
(4, 35.00, '2025-08-01 08:00:00'),
(5, 6.80, '2025-08-01 08:00:00'),
(6, 50.20, '2025-08-02 07:00:00'),
(7, 34.10, '2025-08-02 07:00:00'),
(8, 28.90, '2025-08-02 09:00:00'),
(9, 85000.00, '2025-08-02 12:00:00'),
(10, 55.30, '2025-08-03 06:00:00'),
(11, 12.50, '2025-08-03 06:00:00'),
(12, 27.40, '2025-08-03 10:00:00'),
(13, 320.00, '2025-08-03 10:00:00');

INSERT INTO alerts (sensor_id, alert_type, severity, message, is_resolved) VALUES
(1, 'Low Moisture', 'high', 'Soil moisture dropped below 30%', FALSE),
(2, 'High Temperature', 'medium', 'Temperature exceeded 37°C', TRUE),
(5, 'pH Abnormal', 'critical', 'Soil pH dropped to 4.2 - too acidic', FALSE),
(7, 'Sensor Offline', 'low', 'Temperature sensor went inactive', FALSE),
(9, 'High Light', 'medium', 'Light intensity unusually high', TRUE),
(10, 'Low Moisture', 'high', 'Sugarcane field moisture critical', FALSE);

INSERT INTO thresholds (sensor_id, min_value, max_value, alert_enabled) VALUES
(1, 30.00, 80.00, TRUE),
(2, 10.00, 40.00, TRUE),
(3, 40.00, 90.00, TRUE),
(4, 25.00, 75.00, TRUE),
(5, 5.50, 8.00, TRUE),
(6, 30.00, 80.00, TRUE),
(8, 20.00, 70.00, TRUE),
(9, 10000.00, 100000.00, FALSE),
(10, 35.00, 85.00, TRUE),
(11, 0.00, 50.00, TRUE);

INSERT INTO irrigation_systems (farm_id, system_type, status, last_activated, water_usage_liters) VALUES
(1, 'Drip', 'on', '2025-08-01 06:30:00', 250.00),
(2, 'Sprinkler', 'off', '2025-07-28 07:00:00', 500.00),
(3, 'Flood', 'off', '2025-07-30 05:00:00', 1200.00),
(4, 'Drip', 'on', '2025-08-02 06:00:00', 180.00),
(5, 'Sprinkler', 'on', '2025-08-03 05:30:00', 800.00),
(6, 'Drip', 'off', '2025-07-25 08:00:00', 150.00);

INSERT INTO irrigation_logs (irrigation_id, sensor_id, action, triggered_by, duration_minutes) VALUES
(1, 1, 'on', 'auto', 45),
(1, 1, 'off', 'auto', NULL),
(2, 4, 'on', 'manual', 60),
(2, 4, 'off', 'manual', NULL),
(3, 6, 'on', 'manual', 120),
(4, 8, 'on', 'auto', 30),
(5, 10, 'on', 'auto', 90),
(5, 10, 'off', 'auto', NULL);

INSERT INTO crop_health (farm_id, assessment_date, health_status, pest_detected, disease_detected, notes) VALUES
(1, '2025-08-01', 'healthy', FALSE, FALSE, 'rice looking good ngl'),
(2, '2025-08-01', 'moderate', TRUE, FALSE, 'some aphids spotted on cotton'),
(3, '2025-08-02', 'healthy', FALSE, FALSE, 'wheat growing fine'),
(4, '2025-08-02', 'poor', TRUE, TRUE, 'groundnut got leaf spot and bugs'),
(5, '2025-08-03', 'moderate', FALSE, TRUE, 'sugarcane red rot detected ugh'),
(6, '2025-08-03', 'healthy', FALSE, FALSE, 'coffee plants are vibing');

INSERT INTO weather_data (farm_id, temperature, humidity, rainfall_mm, wind_speed, recorded_at) VALUES
(1, 32.50, 75.00, 0.00, 12.30, '2025-08-01 06:00:00'),
(1, 38.20, 62.00, 0.00, 8.50, '2025-08-01 12:00:00'),
(1, 28.90, 80.00, 5.20, 15.00, '2025-08-01 18:00:00'),
(2, 30.10, 70.00, 0.00, 10.00, '2025-08-01 08:00:00'),
(3, 35.60, 55.00, 0.00, 6.80, '2025-08-02 10:00:00'),
(3, 29.00, 78.00, 15.00, 20.00, '2025-08-02 16:00:00'),
(4, 37.80, 48.00, 0.00, 5.00, '2025-08-02 12:00:00'),
(5, 33.00, 72.00, 8.50, 11.00, '2025-08-03 06:00:00'),
(6, 25.40, 85.00, 22.00, 9.00, '2025-08-03 07:00:00');


-- ========== some queries ==========

-- 1. get all sensors for a specific farm
SELECT s.sensor_id, st.type_name, s.model_name, s.status
FROM sensors s
JOIN sensor_types st ON s.type_id = st.type_id
WHERE s.farm_id = 1;

-- 2. latest readings from all sensors
SELECT s.sensor_id, st.type_name, sr.reading_value, st.unit, sr.reading_time
FROM sensor_readings sr
JOIN sensors s ON sr.sensor_id = s.sensor_id
JOIN sensor_types st ON s.type_id = st.type_id
ORDER BY sr.reading_time DESC;

-- 3. unresolved alerts
SELECT a.alert_id, f.farm_name, st.type_name, a.alert_type, a.severity, a.message
FROM alerts a
JOIN sensors s ON a.sensor_id = s.sensor_id
JOIN farms f ON s.farm_id = f.farm_id
JOIN sensor_types st ON s.type_id = st.type_id
WHERE a.is_resolved = FALSE
ORDER BY a.severity DESC;

-- 4. avg soil moisture per farm
SELECT f.farm_name, ROUND(AVG(sr.reading_value), 2) AS avg_moisture
FROM sensor_readings sr
JOIN sensors s ON sr.sensor_id = s.sensor_id
JOIN sensor_types st ON s.type_id = st.type_id
JOIN farms f ON s.farm_id = f.farm_id
WHERE st.type_name = 'Soil Moisture'
GROUP BY f.farm_name;

-- 5. farms with pest or disease problems
SELECT f.farm_name, ch.health_status, ch.pest_detected, ch.disease_detected, ch.notes
FROM crop_health ch
JOIN farms f ON ch.farm_id = f.farm_id
WHERE ch.pest_detected = TRUE OR ch.disease_detected = TRUE;

-- 6. total water usage per farm
SELECT f.farm_name, SUM(ir.water_usage_liters) AS total_water
FROM irrigation_systems ir
JOIN farms f ON ir.farm_id = f.farm_id
GROUP BY f.farm_name
ORDER BY total_water DESC;

-- 7. sensors that breached thresholds
SELECT s.sensor_id, st.type_name, sr.reading_value, t.min_value, t.max_value,
       CASE
           WHEN sr.reading_value < t.min_value THEN 'Below Min'
           WHEN sr.reading_value > t.max_value THEN 'Above Max'
           ELSE 'Normal'
       END AS status
FROM sensor_readings sr
JOIN sensors s ON sr.sensor_id = s.sensor_id
JOIN sensor_types st ON s.type_id = st.type_id
JOIN thresholds t ON s.sensor_id = t.sensor_id
WHERE sr.reading_value < t.min_value OR sr.reading_value > t.max_value;

-- 8. weather report for a farm
SELECT w.temperature, w.humidity, w.rainfall_mm, w.wind_speed, w.recorded_at
FROM weather_data w
WHERE w.farm_id = 1
ORDER BY w.recorded_at DESC;

-- 9. count sensors per farm
SELECT f.farm_name, COUNT(s.sensor_id) AS sensor_count
FROM farms f
LEFT JOIN sensors s ON f.farm_id = s.farm_id
GROUP BY f.farm_name;

-- 10. irrigation history with sensor trigger info
SELECT f.farm_name, ir.system_type, il.action, il.triggered_by, il.duration_minutes, il.timestamp
FROM irrigation_logs il
JOIN irrigation_systems ir ON il.irrigation_id = ir.irrigation_id
JOIN farms f ON ir.farm_id = f.farm_id
ORDER BY il.timestamp DESC;

-- 11. nested subquery - farms with above avg moisture readings
SELECT f.farm_name, f.crop_type
FROM farms f
WHERE f.farm_id IN (
    SELECT s.farm_id
    FROM sensors s
    JOIN sensor_readings sr ON s.sensor_id = sr.sensor_id
    JOIN sensor_types st ON s.type_id = st.type_id
    WHERE st.type_name = 'Soil Moisture'
    GROUP BY s.farm_id
    HAVING AVG(sr.reading_value) > (
        SELECT AVG(sr2.reading_value)
        FROM sensor_readings sr2
        JOIN sensors s2 ON sr2.sensor_id = s2.sensor_id
        JOIN sensor_types st2 ON s2.type_id = st2.type_id
        WHERE st2.type_name = 'Soil Moisture'
    )
);

-- 12. farmers with multiple farms
SELECT fa.name, COUNT(f.farm_id) AS num_farms
FROM farmers fa
JOIN farms f ON fa.farmer_id = f.farmer_id
GROUP BY fa.name
HAVING COUNT(f.farm_id) > 1;
