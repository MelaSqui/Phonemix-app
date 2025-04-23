const jwt = require('jsonwebtoken');
require('dotenv').config();

const JWTHandler = {
  generate(payload) {
    if (!process.env.JWT_SECRET) {
      throw new Error('JWT_SECRET no está definido en .env');
    }
    return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });
  },
};

module.exports = JWTHandler;
