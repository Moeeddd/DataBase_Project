const pool = require("../config/db");

exports.createBooking = async (req, res) => {
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    const { customer_id, vehicle_id, driver_id, pickup_date, return_date } = req.body;

    await connection.query(
      `INSERT INTO Rental_Booking
       (customer_id, vehicle_id, driver_id, booking_status, pickup_date, return_date)
       VALUES (?, ?, ?, 'Pending', ?, ?)`,
      [customer_id, vehicle_id, driver_id, pickup_date, return_date]
    );

    await connection.commit();
    res.json({ message: "Booking created successfully" });

  } catch (err) {
    await connection.rollback();
    res.status(500).json({ error: err.message });
  } finally {
    connection.release();
  }
};

exports.purchaseVehicle = async (req, res) => {
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    const { vehicle_id, customer_id, price } = req.body;

    await connection.query(
      `INSERT INTO Purchases
       (vehicle_id, customer_id, price, date, status)
       VALUES (?, ?, ?, CURDATE(), 'Pending')`,
      [vehicle_id, customer_id, price]
    );

    await connection.commit();
    res.json({ message: "Purchase recorded successfully" });

  } catch (err) {
    await connection.rollback();
    res.status(500).json({ error: err.message });
  } finally {
    connection.release();
  }
};