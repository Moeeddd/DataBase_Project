CREATE DATABASE ADBMS_project;
use ADBMS_project;
-- DROP DATABASE ADBMS_project;

CREATE TABLE Vehicle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    registration_year INT CHECK (registration_year >= 1980),
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    transmission VARCHAR(20) CHECK (transmission IN ('Manual','Automatic')),
    mileage INT CHECK (mileage >= 0)
);

CREATE TABLE Driver (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE,
    address TEXT,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    available BOOLEAN DEFAULT TRUE
);

CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    driver_id INT UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE,
    address TEXT,
    license_number VARCHAR(50) UNIQUE,
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE Rental_Booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    driver_id INT,
    booking_status VARCHAR(20) 
        CHECK (booking_status IN ('Pending','Confirmed','Cancelled','Completed')),
    pickup_date DATE NOT NULL,
    return_date DATE NOT NULL,
    CHECK (return_date >= pickup_date),

    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE Maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    service_date DATE NOT NULL,
    next_service_mileage INT CHECK (next_service_mileage > 0),
    service_type VARCHAR(100),

    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id)
        ON DELETE CASCADE
);

CREATE TABLE Insurance (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    provider VARCHAR(100),
    start_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    premium_amount DECIMAL(10,2) CHECK (premium_amount > 0),
    CHECK (expiry_date > start_date),

    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id)
        ON DELETE CASCADE
);

CREATE TABLE Purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    customer_id INT NOT NULL,
    price DECIMAL(12,2) CHECK (price > 0),
    date DATE NOT NULL,
    status VARCHAR(20)
        CHECK (status IN ('Pending','Completed','Cancelled')),

    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    purchase_id INT,
    payment_type VARCHAR(20)
        CHECK (payment_type IN ('Booking','Purchase')),
    amount DECIMAL(10,2) CHECK (amount > 0),
    method VARCHAR(30),
    isPaid BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (booking_id) REFERENCES Rental_Booking(booking_id),
    FOREIGN KEY (purchase_id) REFERENCES Purchases(purchase_id)
);

CREATE TABLE Damage_Report (
    damage_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    policy_id INT,
    damage_description TEXT,
    damage_part VARCHAR(100),
    repair_cost DECIMAL(10,2) DEFAULT 0,
    inspection_cost DECIMAL(10,2) DEFAULT 0,
    isResolved BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (booking_id) REFERENCES Rental_Booking(booking_id),
    FOREIGN KEY (policy_id) REFERENCES Insurance(policy_id)
);

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE,
    isActive BOOLEAN DEFAULT TRUE
);

-- INDEXES
CREATE INDEX idx_vehicle_make ON Vehicle(make);
CREATE INDEX idx_booking_vehicle ON Rental_Booking(vehicle_id);
CREATE INDEX idx_booking_customer ON Rental_Booking(customer_id);
CREATE INDEX idx_payment_booking ON Payments(booking_id);
CREATE INDEX idx_purchase_customer ON Purchases(customer_id);
CREATE INDEX idx_damage_booking ON Damage_Report(booking_id);

-- TRIGGERS
-- Make Driver Unavailable
DELIMITER $$
CREATE TRIGGER trg_driver_unavailable
AFTER UPDATE ON Rental_Booking
FOR EACH ROW
BEGIN
    IF NEW.booking_status = 'Confirmed' THEN
        UPDATE Driver
        SET available = FALSE
        WHERE driver_id = NEW.driver_id;
    END IF;
END$$
DELIMITER ;
DELIMITER $$

-- Auto Complete Booking
CREATE TRIGGER trg_auto_complete
BEFORE UPDATE ON Rental_Booking
FOR EACH ROW
BEGIN
    IF NEW.return_date < CURDATE() THEN
        SET NEW.booking_status = 'Completed';
    END IF;
END$$
DELIMITER ;
DELIMITER $$

-- Prevent Payment Without Reference
CREATE TRIGGER trg_payment_validation
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    IF NEW.booking_id IS NULL AND NEW.purchase_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment must reference booking or purchase';
    END IF;
END$$
DELIMITER ;

-- VIEWS
-- Active Bookings
CREATE VIEW Active_Bookings AS
SELECT b.booking_id,
       c.name AS customer_name,
       CONCAT(v.make, ' ', v.model) AS vehicle,
       b.pickup_date,
       b.return_date,
       b.booking_status
FROM Rental_Booking b
JOIN Customer c ON b.customer_id = c.customer_id
JOIN Vehicle v ON b.vehicle_id = v.id
WHERE b.booking_status IN ('Pending','Confirmed');

-- Vehicle Insurance Status
CREATE VIEW Vehicle_Insurance_Status AS
SELECT v.id,
       v.make,
       v.model,
       i.provider,
       i.expiry_date,
       CASE 
           WHEN i.expiry_date >= CURDATE() THEN 'Valid'
           ELSE 'Expired'
       END AS insurance_status
FROM Vehicle v
LEFT JOIN Insurance i ON v.id = i.vehicle_id;

-- Customer Payment Summary
CREATE VIEW Customer_Payment_Summary AS
SELECT c.customer_id,
       c.name,
       SUM(p.amount) AS total_paid
FROM Customer c
JOIN Rental_Booking b ON c.customer_id = b.customer_id
JOIN Payments p ON b.booking_id = p.booking_id
WHERE p.isPaid = TRUE
GROUP BY c.customer_id, c.name;