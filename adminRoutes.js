const express = require("express");
const router = express.Router();
const adminController = require("../controllers/adminController");
const { verifyToken } = require("../middleware/authMiddleware");
const { checkRole } = require("../middleware/roleMiddleware");

router.post("/add-vehicle", verifyToken, checkRole(["Admin"]), adminController.addVehicle);
router.post("/add-driver", verifyToken, checkRole(["Admin"]), adminController.addDriver);
router.post("/confirm-booking", verifyToken, checkRole(["Admin"]), adminController.confirmBooking);
router.post("/complete-purchase", verifyToken, checkRole(["Admin"]), adminController.completePurchase);

router.get("/active-bookings", verifyToken, checkRole(["Admin"]), adminController.viewActiveBookings);
router.get("/insurance-status", verifyToken, checkRole(["Admin"]), adminController.viewInsuranceStatus);
router.get("/payment-summary", verifyToken, checkRole(["Admin"]), adminController.viewPaymentSummary);

module.exports = router;