const express = require('express');
const router = express.Router();
const ControlParentalController = require('./ControlParentalController');

router.get('/children', ControlParentalController.getChildren);
router.get('/mensajes-especialista', ControlParentalController.getRecentMessages); // 🔹 Se corrige la ruta para coincidir con Flutter

module.exports = router;
