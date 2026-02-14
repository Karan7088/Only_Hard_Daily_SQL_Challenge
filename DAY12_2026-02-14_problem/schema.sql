drop table if exists buses;
create table buses
(
	bus_id			int unique,
	arrival_time	int,
	capacity		int
);

drop table if exists Passengers;
create table Passengers
(
	passenger_id	int unique,
	arrival_time	int
);



