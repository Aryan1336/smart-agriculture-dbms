# Smart Agriculture Sensor Database - ER Diagram

```mermaid
erDiagram
    FARMERS {
        int farmer_id PK
        varchar name
        varchar phone
        varchar email
        text address
        timestamp created_at
    }

    FARMS {
        int farm_id PK
        int farmer_id FK
        varchar farm_name
        varchar location
        decimal area_hectares
        varchar soil_type
        varchar crop_type
    }

    SENSOR_TYPES {
        int type_id PK
        varchar type_name
        varchar unit
        text description
    }

    SENSORS {
        int sensor_id PK
        int farm_id FK
        int type_id FK
        varchar model_name
        varchar manufacturer
        date installation_date
        varchar status
        decimal latitude
        decimal longitude
    }

    SENSOR_READINGS {
        int reading_id PK
        int sensor_id FK
        decimal reading_value
        timestamp reading_time
    }

    ALERTS {
        int alert_id PK
        int sensor_id FK
        varchar alert_type
        varchar severity
        text message
        boolean is_resolved
        timestamp created_at
        timestamp resolved_at
    }

    THRESHOLDS {
        int threshold_id PK
        int sensor_id FK
        decimal min_value
        decimal max_value
        boolean alert_enabled
    }

    IRRIGATION_SYSTEMS {
        int irrigation_id PK
        int farm_id FK
        varchar system_type
        varchar status
        timestamp last_activated
        decimal water_usage_liters
    }

    IRRIGATION_LOGS {
        int log_id PK
        int irrigation_id FK
        int sensor_id FK
        varchar action
        varchar triggered_by
        int duration_minutes
        timestamp timestamp
    }

    CROP_HEALTH {
        int health_id PK
        int farm_id FK
        date assessment_date
        varchar health_status
        boolean pest_detected
        boolean disease_detected
        text notes
    }

    WEATHER_DATA {
        int weather_id PK
        int farm_id FK
        decimal temperature
        decimal humidity
        decimal rainfall_mm
        decimal wind_speed
        timestamp recorded_at
    }

    FARMERS ||--o{ FARMS : "owns"
    FARMS ||--o{ SENSORS : "has"
    SENSOR_TYPES ||--o{ SENSORS : "classifies"
    SENSORS ||--o{ SENSOR_READINGS : "generates"
    SENSORS ||--o{ ALERTS : "triggers"
    SENSORS ||--o{ THRESHOLDS : "configured with"
    FARMS ||--o{ IRRIGATION_SYSTEMS : "has"
    IRRIGATION_SYSTEMS ||--o{ IRRIGATION_LOGS : "logs"
    SENSORS ||--o{ IRRIGATION_LOGS : "triggers"
    FARMS ||--o{ CROP_HEALTH : "assessed in"
    FARMS ||--o{ WEATHER_DATA : "recorded at"
```

## Relationships Summary

| Relationship | Type | Description |
|---|---|---|
| Farmers → Farms | 1:N | one farmer can own multiple farms |
| Farms → Sensors | 1:N | one farm can have multiple sensors |
| Sensor_Types → Sensors | 1:N | each sensor has one type |
| Sensors → Sensor_Readings | 1:N | each sensor spits out many readings |
| Sensors → Alerts | 1:N | sensors can trigger multiple alerts |
| Sensors → Thresholds | 1:N | each sensor can have threshold configs |
| Farms → Irrigation_Systems | 1:N | one farm can have irrigation setups |
| Irrigation_Systems → Irrigation_Logs | 1:N | logs for each irrigation action |
| Sensors → Irrigation_Logs | 1:N | sensors can trigger irrigation |
| Farms → Crop_Health | 1:N | multiple health assessments per farm |
| Farms → Weather_Data | 1:N | weather recorded over time per farm |
