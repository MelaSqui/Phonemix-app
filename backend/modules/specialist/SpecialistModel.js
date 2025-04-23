const pool = require('../../shared/Database');

const SpecialistModel = {
  async findByEmail(email) {
    const result = await pool.query('SELECT * FROM especialistas WHERE email = $1', [email]);
    return result.rows[0];
  },
};

module.exports = SpecialistModel;
