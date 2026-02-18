CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Referrals (
    referrer_id INT,
    referee_id INT,
    signup_date DATE,
    PRIMARY KEY (referrer_id, referee_id),
    FOREIGN KEY (referrer_id) REFERENCES Users(user_id),
    FOREIGN KEY (referee_id) REFERENCES Users(user_id)
);