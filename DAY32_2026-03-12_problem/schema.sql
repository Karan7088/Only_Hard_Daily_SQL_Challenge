CREATE TABLE listings (
    listing_id INT PRIMARY KEY,
    city VARCHAR(50),
    base_price INT
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    listing_id INT,
    booking_date DATE
);


