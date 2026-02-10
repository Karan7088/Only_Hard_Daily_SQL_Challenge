🧠 Daily SQL Challenge – Sensor Analytics (Hard)

DATE:2026-02-10

📌 Problem Summary

You are given sensor data collected over time from different locations.
Each sensor records temperature readings at irregular intervals.

Your task is to build a sensor-level summary table that captures:

basic statistics

inactivity behavior

overheating behavior

anomaly detection

This challenge tests your ability to combine aggregations, time-based reasoning, and edge-case handling.

📂 Input Tables
Sensors

Contains the list of sensors and their locations.

Sensor Readings

Contains timestamped temperature readings.

Temperatures can be NULL

Readings are not guaranteed to be continuous

Sensors may have very few readings

📊 Expected Output

One row per sensor with the following columns:

📐 Column Rules & Calculations
sensor_id

Unique identifier of the sensor.

location

Location where the sensor is installed.

total_readings

Count of all readings for the sensor

Includes rows with NULL temperature

valid_readings

Count of readings where temperature is NOT NULL

avg_temperature

Average of all valid temperature values

NULL temperatures are ignored

min_temperature

Minimum valid temperature recorded by the sensor

max_temperature

Maximum valid temperature recorded by the sensor

max_temperature_jump

Maximum change between two consecutive temperature readings

Calculated per sensor using reading order

First reading has no previous comparison

longest_inactivity_hours

Longest time gap (in hours) between consecutive readings

Calculated per sensor using timestamps

max_overheated_duration_hours

Longest continuous sequence where temperature ≥ 80

Sequence breaks when temperature drops below 80

Only consecutive readings are considered

inactive_flag

Indicates whether a sensor was inactive for a long period

Rule:

inactive_flag = 1 if longest_inactivity_hours > 24
else 0

anomaly_temp_flag

Indicates extreme temperature behavior

Rule:

anomaly_temp_flag = 1 if:
    max_temperature > 100
    OR
    min_temperature < 0
else 0

⚠️ Important Edge Cases to Handle

Sensors with only one reading

Sensors with NULL temperature values

Large gaps between readings

Sensors that never overheat

Sudden temperature spikes

Extreme temperature values

🎯 What This Challenge Tests

Window function thinking

Correct use of aggregation levels

Handling NULLs safely

Time-based calculations

Translating business rules into SQL logic

✅ Goal

Produce a correct sensor-level summary that reflects:

usage patterns

reliability

abnormal behavior

This is a realistic hard SQL challenge commonly seen in analytics and data engineering interviews.