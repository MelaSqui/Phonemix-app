const { Pool } = require('pg');
require('dotenv').config();

const isTestEnv = process.env.NODE_ENV === "test";

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: isTestEnv ? process.env.DB_NAME_TEST : process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 5432,
});
module.exports = pool;

// 🔹 Conexión segura con eventos de error controlados
pool.on('connect', () => {
  if (!isTestEnv) console.log("✅ Conexión exitosa a PostgreSQL");
});
pool.on('error', (err) => console.error("❌ Error de conexión a PostgreSQL:", err.message));

async function getChildrenBySpecialist(specialist_id) {
  try {
    const result = await pool.query("SELECT * FROM ninos WHERE especialista_id = $1", [specialist_id]);
    if (!isTestEnv) console.log("✅ Niños obtenidos:", result.rows);
    return result.rows;
  } catch (error) {
    console.error("❌ Error en getChildrenBySpecialist:", error.message);
    throw new Error("No se pudieron obtener los niños.");
  }
}

async function getSpecialistStats(specialist_id) {
  try {
    const result = await pool.query(`
      SELECT COUNT(*) AS children_count,
             AVG(progress) AS average_progress,
             SUM(completed_activities) AS completed_activities
      FROM ninos WHERE especialista_id = $1
    `, [specialist_id]);

    if (!isTestEnv) console.log("✅ Estadísticas obtenidas:", result.rows);
    return result.rows[0];
  } catch (error) {
    console.error("❌ Error en getSpecialistStats:", error.message);
    throw new Error("No se pudieron obtener las estadísticas.");
  }
}

async function sendEvaluation(specialist_id, padre_id, mensaje) {
  try {
    await pool.query(
      "INSERT INTO mensajes_especialista (especialista_id, padre_id, mensaje, fecha) VALUES ($1, $2, $3, NOW())",
      [specialist_id, padre_id, mensaje]
    );
    if (!isTestEnv) console.log("✅ Evaluación enviada correctamente.");
  } catch (error) {
    console.error("❌ Error en sendEvaluation:", error.message);
    throw new Error("No se pudo enviar la evaluación.");
  }
}

async function getMessagesBySpecialist(specialist_id) {
  try {
    const result = await pool.query(
      "SELECT * FROM mensajes_especialista WHERE especialista_id = $1",
      [specialist_id]
    );
    if (!isTestEnv) console.log("✅ Mensajes recuperados:", result.rows);
    return result.rows;
  } catch (error) {
    console.error("❌ Error en getMessagesBySpecialist:", error.message);
    throw new Error("No se pudieron obtener los mensajes.");
  }
}

// 🔹 Cierra la conexión de la base de datos al finalizar las pruebas
const closePool = async () => {
  await pool.end();
  console.log("✅ Conexión a la base de datos cerrada.");
};

module.exports = { getChildrenBySpecialist, getSpecialistStats, sendEvaluation, getMessagesBySpecialist, closePool };
