const { Pool } = require("pg");
require("dotenv").config();

const isTestEnv = process.env.NODE_ENV === "test";

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: isTestEnv ? process.env.DB_NAME_TEST : process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 5432,
});

pool.on("connect", () => {
  if (!isTestEnv) console.log("✅ Conexión exitosa a PostgreSQL");
});

pool.on("error", (err) => console.error("❌ Error en la conexión a PostgreSQL:", err.message));

const closePool = async () => {
  await pool.end();
  console.log("✅ Conexión a la base de datos cerrada.");
};

module.exports = { pool, closePool, isTestEnv };
