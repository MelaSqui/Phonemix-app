const { pool } = require("../../shared/Database");
const ControlParentalModel = require("./ControlParentalModelo");
const MensajesEspecialistaModel = require("./MensajesEspecialistaModel");

async function getChildrenByParent(padre_id) {
  try {
    console.log(`Buscando datos de control parental con padre_id: ${padre_id}`);

    const result = await pool.query("SELECT * FROM control_parental WHERE padre_id = $1", [padre_id]);

    if (!result.rows.length) {
      throw new Error(`No hay niños registrados para padre_id: ${padre_id}`);
    }

    console.log("✅ Datos obtenidos:", result.rows);
    return result.rows;
  } catch (error) {
    console.error("❌ Error en la consulta de Control Parental:", error.message);
    throw new Error(`No se pudieron obtener los niños: ${error.message}`);
  }
}

async function getMessagesByParent(padre_id) {
  try {
    if (!padre_id) {
      throw new Error("❌ Se requiere padre_id.");
    }

    const result = await pool.query("SELECT * FROM mensajes_especialista WHERE padre_id = $1", [padre_id]);

    if (!result.rows.length) {
      throw new Error(`❌ No hay mensajes para padre_id ${padre_id}`);
    }

    console.log("✅ Mensajes obtenidos:", result.rows);
    return result.rows;
  } catch (error) {
    console.error("❌ Error en getMessagesByParent:", error.message);
    throw new Error("❌ No se pudieron obtener los mensajes.");
  }
}

module.exports = { getChildrenByParent, getMessagesByParent };
