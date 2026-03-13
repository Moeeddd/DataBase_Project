const express = require("express");
const router = express.Router();
const customerController = require("../controllers/customerController");
const { verifyToken } = require("../middleware/authMiddleware");
const { checkRole } = require("../middleware/roleMiddleware");

router.post("/book-vehicle", verifyToken, checkRole(["Customer"]), customerController.createBooking);
router.post("/purchase-vehicle", verifyToken, checkRole(["Customer"]), customerController.purchaseVehicle);

module.exports = router;