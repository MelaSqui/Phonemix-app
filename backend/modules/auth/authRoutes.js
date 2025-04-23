const express = require('express');
const router = express.Router();
const AuthController = require('./authController');

router.post('/login', AuthController.login);

router.post('/login-child', AuthController.loginChild);

module.exports = router;
