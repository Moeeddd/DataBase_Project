const pool = require("../config/db");

/* =========================
   ADD VEHICLE
========================= */
exports.addVehicle = async (req, res) => {
  const { type, registration_year, make, model, transmission, mileage } = req.body;

  try {
    await pool.query(
      `INSERT INTO Vehicle 
      (type, registration_year, make, model, transmission, mileage)
      VALUES (?, ?, ?, ?, ?, ?)`,
      [type, registration_year, make, model, transmission, mileage]
    );

    res.json({ message: "Vehicle added successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* =========================
   ADD DRIVER
========================= */
exports.addDriver = async (req, res) => {
  const { name, email, phone_number, address, license_number, password } = req.body;

  const bcrypt = require("bcryptjs");
  const hashedPassword = await bcrypt.hash(password, 10);

  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    await connection.query(
      `INSERT INTO Driver 
       (name, email, phone_number, address, license_number)
       VALUES (?, ?, ?, ?, ?)`,
      [name, email, phone_number, address, license_number]
    );

    await connection.query(
      `INSERT INTO Users (name, role, email, password, hire_date)
       VALUES (?, 'Driver', ?, ?, CURDATE())`,
      [name, email, hashedPassword]
    );

    await connection.commit();
    res.json({ message: "Driver added successfully" });

  } catch (err) {
    await connection.rollback();
    res.status(500).json({ error: err.message });
  } finally {
    connection.release();
  }
};

/* =========================
   CONFIRM BOOKING
========================= */
exports.confirmBooking = async (req, res) => {
  const { booking_id } = req.body;

  try {
    await pool.query(
      `UPDATE Rental_Booking 
       SET booking_status='Confirmed'
       WHERE booking_id=?`,
      [booking_id]
    );

    res.json({ message: "Booking confirmed" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* =========================
   COMPLETE PURCHASE
========================= */
exports.completePurchase = async (req, res) => {
  const { purchase_id } = req.body;

  try {
    await pool.query(
      `UPDATE Purchases 
       SET status='Completed'
       WHERE purchase_id=?`,
      [purchase_id]
    );

    res.json({ message: "Purchase completed" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* =========================
   VIEW REPORTS (VIEWS)
========================= */
exports.viewActiveBookings = async (req, res) => {
  const [rows] = await pool.query("SELECT * FROM Active_Bookings");
  res.json(rows);
};

exports.viewInsuranceStatus = async (req, res) => {
  const [rows] = await pool.query("SELECT * FROM Vehicle_Insurance_Status");
  res.json(rows);
};

exports.viewPaymentSummary = async (req, res) => {
  const [rows] = await pool.query("SELECT * FROM Customer_Payment_Summary");
  res.json(rows);
};