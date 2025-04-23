const pool = require('../../shared/Database'); // Asegúrate de que la ruta sea correcta

const UserModel = {
    async create(data) {
        const { nombre, email, password, fecha_nacimiento } = data;
        const result = await pool.query(
            `INSERT INTO usuarios (nombre, email, password, fecha_nacimiento)
             VALUES ($1, $2, $3, $4) RETURNING *`,
            [nombre, email, password, fecha_nacimiento]
        );
        return result.rows[0];
    },

    async findByEmail(email) {
        const result = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
        return result.rows[0];
    },
};

module.exports = UserModel;
