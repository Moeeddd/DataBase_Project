const pool = require("../config/db");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

exports.registerCustomer = async (req, res) => {
  const { name, email, phone_number, address, license_number, password } = req.body;

  const hashedPassword = await bcrypt.hash(password, 10);
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    // Insert into Customer table
    const [customerResult] = await connection.query(
      `INSERT INTO Customer (name, email, phone_number, address, license_number)
       VALUES (?, ?, ?, ?, ?)`,
      [name, email, phone_number, address, license_number]
    );

    const customerId = customerResult.insertId;

    // Insert into Users table
    await connection.query(
      `INSERT INTO Users (name, role, email, password, hire_date, isActive)
       VALUES (?, 'Customer', ?, ?, CURDATE(), TRUE)`,
      [name, email, hashedPassword]
    );

    await connection.commit();

    res.json({
      message: "Customer registered successfully",
      customer_id: customerId
    });

  } catch (err) {

    await connection.rollback();
    res.status(500).json({ error: err.message });

  } finally {

    connection.release();

  }
};

exports.login = async (req, res) => {

  const { email, password } = req.body;

  const [users] = await pool.query(
    "SELECT * FROM Users WHERE email=? AND isActive=TRUE",
    [email]
  );

  if (users.length === 0) {
    return res.status(400).json({ message: "User not found" });
  }

  //const user = users[0];
  //if (user.password !== password) {
  //  return res.status(401).json({ message: "Invalid credentials" });}
  const valid = await bcrypt.compare(password, user.password);
  
  if (!valid) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  const token = jwt.sign(
    { id: user.user_id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: "1d" }
  );

  res.json({ token, role: user.role });

};

 