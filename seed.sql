USE ADBMS_project;

INSERT INTO Vehicle (type, registration_year, make, model, transmission, mileage) VALUES
('Sedan',2019,'Toyota','Corolla','Automatic',45000),
('SUV',2021,'Honda','BR-V','Manual',30000),
('Sedan',2018,'Suzuki','Ciaz','Automatic',55000),
('Hatchback',2020,'Suzuki','Cultus','Manual',25000),
('SUV',2022,'KIA','Sportage','Automatic',20000),
('Sedan',2017,'Toyota','Yaris','Manual',60000),
('SUV',2023,'Hyundai','Tucson','Automatic',15000),
('Hatchback',2019,'Suzuki','Alto','Manual',40000),
('Sedan',2021,'Honda','City','Automatic',22000),
('SUV',2016,'Toyota','Fortuner','Automatic',75000),
('Sedan',2015,'Toyota','Camry','Automatic',90000),
('Hatchback',2022,'Suzuki','WagonR','Manual',12000),
('SUV',2020,'MG','HS','Automatic',28000),
('Sedan',2018,'Honda','Civic','Automatic',50000),
('SUV',2019,'KIA','Sorento','Automatic',35000),
('Hatchback',2017,'Suzuki','Mehran','Manual',70000),
('Sedan',2023,'Toyota','Corolla Cross','Automatic',10000),
('SUV',2022,'Changan','Oshan X7','Automatic',18000),
('Sedan',2021,'Proton','Saga','Manual',26000),
('SUV',2020,'Isuzu','D-Max','Manual',32000);

INSERT INTO Driver (name,email,phone_number,address,license_number,available) VALUES
('Ahmed Raza','ahmed.raza@gmail.com','03001234501','Lahore','LIC1001',TRUE),
('Usman Ali','usman.ali@gmail.com','03001234502','Karachi','LIC1002',TRUE),
('Bilal Khan','bilal.khan@gmail.com','03001234503','Islamabad','LIC1003',TRUE),
('Hamza Tariq','hamza.tariq@gmail.com','03001234504','Rawalpindi','LIC1004',TRUE),
('Zain Abbas','zain.abbas@gmail.com','03001234505','Faisalabad','LIC1005',TRUE),
('Ali Hassan','ali.hassan@gmail.com','03001234506','Multan','LIC1006',TRUE),
('Umar Farooq','umar.farooq@gmail.com','03001234507','Sialkot','LIC1007',TRUE),
('Saad Ahmed','saad.ahmed@gmail.com','03001234508','Gujranwala','LIC1008',TRUE),
('Fahad Malik','fahad.malik@gmail.com','03001234509','Peshawar','LIC1009',TRUE),
('Taha Iqbal','taha.iqbal@gmail.com','03001234510','Quetta','LIC1010',TRUE),
('Danish Qureshi','danish.q@gmail.com','03001234511','Lahore','LIC1011',TRUE),
('Imran Sheikh','imran.s@gmail.com','03001234512','Karachi','LIC1012',TRUE),
('Hassan Rauf','hassan.r@gmail.com','03001234513','Islamabad','LIC1013',TRUE),
('Shahzaib Ali','shahzaib.a@gmail.com','03001234514','Multan','LIC1014',TRUE),
('Asad Mahmood','asad.m@gmail.com','03001234515','Sahiwal','LIC1015',TRUE),
('Kamran Yousaf','kamran.y@gmail.com','03001234516','Hyderabad','LIC1016',TRUE),
('Noman Akhtar','noman.a@gmail.com','03001234517','Lahore','LIC1017',TRUE),
('Junaid Khan','junaid.k@gmail.com','03001234518','Karachi','LIC1018',TRUE),
('Shahbaz Ahmed','shahbaz.a@gmail.com','03001234519','Faisalabad','LIC1019',TRUE),
('Rizwan Ali','rizwan.a@gmail.com','03001234520','Rawalpindi','LIC1020',TRUE);

INSERT INTO Customer (driver_id,name,email,phone_number,address,license_number) VALUES
(NULL,'Moeed Ahmad','moeed.ahmad@gmail.com','03101230001','Lahore','CUST2001'),
(NULL,'Ayesha Khan','ayesha.khan@gmail.com','03101230002','Karachi','CUST2002'),
(NULL,'Fatima Noor','fatima.noor@gmail.com','03101230003','Islamabad','CUST2003'),
(NULL,'Hira Malik','hira.malik@gmail.com','03101230004','Lahore','CUST2004'),
(NULL,'Sana Iqbal','sana.iqbal@gmail.com','03101230005','Multan','CUST2005'),
(NULL,'Ali Raza','ali.raza@gmail.com','03101230006','Rawalpindi','CUST2006'),
(NULL,'Talha Ahmed','talha.ahmed@gmail.com','03101230007','Sialkot','CUST2007'),
(NULL,'Maham Tariq','maham.tariq@gmail.com','03101230008','Lahore','CUST2008'),
(NULL,'Hassan Khan','hassan.k@gmail.com','03101230009','Karachi','CUST2009'),
(NULL,'Zoya Ali','zoya.ali@gmail.com','03101230010','Islamabad','CUST2010');

INSERT INTO Rental_Booking 
(customer_id,vehicle_id,driver_id,booking_status,pickup_date,return_date)
VALUES
(1,1,1,'Confirmed','2026-02-01','2026-02-05'),
(2,5,2,'Completed','2026-01-10','2026-01-15'),
(3,3,3,'Pending','2026-03-01','2026-03-03'),
(4,7,4,'Confirmed','2026-02-15','2026-02-18'),
(5,10,5,'Cancelled','2026-02-05','2026-02-06');

INSERT INTO Insurance (vehicle_id,provider,start_date,expiry_date,premium_amount) VALUES
(1,'Adamjee Insurance','2025-01-01','2026-01-01',55000),
(2,'Jubilee Insurance','2025-02-01','2026-02-01',45000),
(3,'EFU Insurance','2025-03-01','2026-03-01',50000),
(4,'State Life','2025-01-15','2026-01-15',30000);

INSERT INTO Payments 
(booking_id,purchase_id,payment_type,amount,method,isPaid)
VALUES
(1,NULL,'Booking',25000,'Credit Card',TRUE),
(2,NULL,'Booking',30000,'Cash',TRUE),
(3,NULL,'Booking',15000,'JazzCash',FALSE);

INSERT INTO Users (name,role,email,hire_date,isActive) VALUES
('Admin Ahmed','Manager','admin@rental.pk','2022-01-01',TRUE),
('Sadia Khan','Accountant','sadia@rental.pk','2023-03-01',TRUE),
('Bilal Tariq','Supervisor','bilal@rental.pk','2024-06-15',TRUE),
('Hina Rauf','Receptionist','hina@rental.pk','2024-09-01',TRUE),
('Usman Sheikh','Maintenance','usman@rental.pk','2023-11-01',TRUE);