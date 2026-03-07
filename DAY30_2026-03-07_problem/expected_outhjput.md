 DAY30 – Airline Seat Reallocation Optimizer
 date-07-03-2026

Dataset Explanation (data.sql)

This file contains the table definitions and sample data required to simulate an airline seat allocation system. The goal of the dataset is to test SQL logic that reallocates passengers into available seats based on seat availability, loyalty priority, and check-in order.

The dataset contains two tables:

seats

passengers

These tables represent airplane seating capacity and passenger booking information.

1. Seats Table
Table Purpose

The seats table defines all available seats in the aircraft and their travel class.

Each row represents one physical seat.

Table Structure
seat_id      INT
seat_class   VARCHAR
Column Explanation
Column	Description
seat_id	Unique identifier for each seat
seat_class	Class of the seat (ECONOMY, PREMIUM, BUSINESS)
Example Data
INSERT INTO seats VALUES
(1,'BUSINESS'),
(2,'BUSINESS'),
(3,'PREMIUM'),
(4,'PREMIUM'),
(5,'ECONOMY'),
(6,'ECONOMY'),
(7,'ECONOMY');
What This Means

The aircraft contains:

Class	Seats
BUSINESS	2
PREMIUM	2
ECONOMY	3

Total seats = 7

2. Passengers Table
Table Purpose

The passengers table contains information about passengers who purchased tickets and checked in for the flight.

These passengers must be assigned seats based on airline upgrade rules.

Table Structure
passenger_id    INT
ticket_class    VARCHAR
loyalty_status  VARCHAR
checkin_time    DATETIME
Column Explanation
Column	Description
passenger_id	Unique passenger identifier
ticket_class	Class the passenger originally booked
loyalty_status	Passenger loyalty tier
checkin_time	Time the passenger checked in
Example Dataset
INSERT INTO passengers VALUES
(101,'ECONOMY','GOLD','2026-03-07 08:00:00'),
(102,'ECONOMY','SILVER','2026-03-07 08:10:00'),
(103,'ECONOMY','NONE','2026-03-07 08:20:00'),
(104,'PREMIUM','GOLD','2026-03-07 08:30:00'),
(105,'ECONOMY','PLATINUM','2026-03-07 08:40:00'),
(106,'BUSINESS','NONE','2026-03-07 08:50:00'),
(107,'ECONOMY','NONE','2026-03-07 09:00:00');
Passenger Breakdown
ECONOMY passengers
Passenger	Loyalty	Checkin
101	GOLD	08:00
102	SILVER	08:10
103	NONE	08:20
105	PLATINUM	08:40
107	NONE	09:00

Total Economy passengers = 5

But Economy seats = 3

Therefore 2 passengers must be upgraded.

PREMIUM passengers
Passenger	Loyalty
104	GOLD

Premium seats = 2

Only 1 passenger booked, so 1 seat remains empty.

BUSINESS passengers
Passenger	Loyalty
106	NONE

Business seats = 2

Only 1 passenger booked, so 1 seat remains empty.

Upgrade Logic

The airline applies the following rules when reallocating passengers.

Rule 1 – Seat Capacity

Each class has limited seats.

Example:

Economy seats = 3
Economy passengers = 5

Two passengers cannot stay in Economy.

Rule 2 – Upgrade Direction

Passengers can only upgrade to the next higher class.

Upgrade path:

ECONOMY → PREMIUM → BUSINESS

Passengers cannot skip classes.

Example:

Economy → Business ❌
Economy → Premium ✔
Rule 3 – Loyalty Priority

Passengers with higher loyalty status are prioritized.

Priority order:

PLATINUM
GOLD
SILVER
NONE

Higher loyalty passengers are upgraded first.

Rule 4 – Check-in Time

If two passengers have the same loyalty level:

The passenger who checked in earlier gets priority.

Example:

Passenger A: GOLD 08:00
Passenger B: GOLD 08:20

Passenger A gets priority.

Dataset Scenario
Step 1 – Economy Overflow

Economy seats = 3
Economy passengers = 5

Passengers ranked by priority:

105 PLATINUM
101 GOLD
102 SILVER
103 NONE
107 NONE

Top 3 stay in Economy:

105
101
102

Overflow passengers:

103
107
Step 2 – Premium Upgrade

Premium capacity = 2
Existing passenger = 104

Remaining seat = 1

Best overflow passenger:

103

Upgraded:

103 → PREMIUM
Step 3 – Business Upgrade

Business capacity = 2
Existing passenger = 106

Remaining seat = 1

Next overflow passenger:

107

Upgraded:

107 → BUSINESS
Expected Final Seat Allocation
passenger_id	seat_class
106	BUSINESS
107	BUSINESS
104	PREMIUM
103	PREMIUM
105	ECONOMY
101	ECONOMY
102	ECONOMY
Purpose of This Dataset

This dataset is designed to test advanced SQL skills such as:

Window functions

Ranking

Conditional logic

Seat optimization

Multi-level upgrades

It simulates a real-world airline seat management system.
