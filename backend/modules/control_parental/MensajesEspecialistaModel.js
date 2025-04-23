const { Pool } = require('pg');
require("dotenv").config();

const isTestEnv = process.env.NODE_ENV === "test"; // 🔹 Asegura que esta línea esté antes de usar `isTestEnv`

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: isTestEnv ? process.env.DB_NAME_TEST : process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 5432,
});

pool.connect()
  .then(() => console.log("✅ Conexión exitosa a PostgreSQL"))
  .catch(err => console.error("❌ Error de conexión a PostgreSQL:", err));

class MensajesEspecialistaModel {
  static async obtenerMensajesPorPadre(padre_id) {
    try {
      console.log("Buscando mensajes del especialista para padre_id:", padre_id);

      const result = await client.query(
        "SELECT id, mensaje, fecha FROM mensajes_especialista WHERE padre_id = $1 ORDER BY fecha DESC",
        [padre_id]
      );

      console.log("Mensajes obtenidos:", result.rows);
      return result.rows;
    } catch (error) {
      console.error("❌ Error en la consulta de mensajes:", error);
      throw new Error("No se pudieron obtener los mensajes.");
    }
  }
}

module.exports = MensajesEspecialistaModel;
