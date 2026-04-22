CREATE DATABASE smart_agriculture;
USE smart_agriculture;

CREATE TABLE Farmer(
 farmer_id INT PRIMARY KEY,
 name VARCHAR(50),
 phone VARCHAR(15),
 address VARCHAR(100)
);

CREATE TABLE Field(
 field_id INT PRIMARY KEY,
 farmer_id INT,
 location VARCHAR(50),
 area FLOAT,
 FOREIGN KEY (farmer_id) REFERENCES Farmer(farmer_id)
);

CREATE TABLE Sensor(
 sensor_id INT PRIMARY KEY,
 field_id INT,
 sensor_type VARCHAR(30),
 status VARCHAR(20),
 FOREIGN KEY (field_id) REFERENCES Field(field_id)
);

CREATE TABLE Sensor_Data(
 data_id INT PRIMARY KEY,
 sensor_id INT,
 reading FLOAT,
 reading_time DATETIME,
 FOREIGN KEY (sensor_id) REFERENCES Sensor(sensor_id)
);
