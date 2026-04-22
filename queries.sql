SELECT * FROM Farmer;
SELECT * FROM Sensor;
SELECT AVG(reading) AS avg_reading FROM Sensor_Data;
SELECT s.sensor_type,d.reading FROM Sensor s JOIN Sensor_Data d ON s.sensor_id=d.sensor_id;
