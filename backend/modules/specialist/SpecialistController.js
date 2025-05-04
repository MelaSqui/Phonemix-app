const SpecialistService = require("./SpecialistService");
const { pool } = require("../../shared/Database");

async function createReport(req, res) {
  try {
    const { specialist_id, padre_id, nino_id, actividad_id, progreso_json, comentario } = req.body;
    const response = await SpecialistService.createReport(specialist_id, padre_id, nino_id, actividad_id, progreso_json, comentario);
    res.status(200).json(response);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getReportsBySpecialist(req, res) {
  try {
    const { specialist_id } = req.query;
    const reports = await SpecialistService.getReportsBySpecialist(specialist_id);
    res.status(200).json(reports);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getReportsByParent(req, res) {
  try {
    const { padre_id } = req.query;
    const reports = await SpecialistService.getReportsByParent(padre_id);
    res.status(200).json(reports);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getReportsByChild(req, res) {
  try {
    const { nino_id } = req.query;
    const reports = await SpecialistService.getReportsByChild(nino_id);
    res.status(200).json(reports);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

// 🔥 Obtener usuarios con niños SIN necesidad de sesiones
async function getUsersWithChildren(req, res) {
  try {
    const { specialist_id } = req.query;
    console.log("🔍 specialist_id recibido:", specialist_id); // 🔥 Depuración

    if (!specialist_id) {
      return res.status(400).json({ message: "❌ specialist_id es requerido." });
    }

    const result = await pool.query(`
      SELECT u.id AS user_id, u.nombre AS user_name, u.email AS user_email, 
             json_agg(json_build_object('id', n.id, 'nombre', n.nombre, 'ultima_conexion', n.ultima_conexion)) AS children
      FROM usuarios u
      LEFT JOIN ninos n ON u.id = n.padre_id
      WHERE n.especialista_id = $1  
      GROUP BY u.id;
    `, [specialist_id]);

    console.log("✅ Resultado SQL:", result.rows); // 🔥 Depuración

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "❌ No se encontraron usuarios con niños asignados a este especialista." });
    }

    res.status(200).json(result.rows);
  } catch (error) {
    console.error("❌ Error en `getUsersWithChildren`:", error); // 🔥 Depuración en consola
    res.status(500).json({ message: "❌ Error interno del servidor." });
  }
}
async function sendEvaluation(req, res) {
  try {
    const { specialist_id, padre_id, mensaje } = req.body;

    if (!specialist_id || !padre_id || !mensaje) {
      return res.status(400).json({ message: "Datos incompletos para la evaluación." });
    }

    await SpecialistService.sendEvaluation(specialist_id, padre_id, mensaje);
    res.json({ message: "✅ Evaluación enviada correctamente." });
  } catch (error) {
    console.error("❌ Error en sendEvaluation:", error);
    res.status(500).json({ message: "Error interno en el servidor." });
  }
}


module.exports = { createReport, getReportsBySpecialist, getReportsByParent, getReportsByChild, getUsersWithChildren, sendEvaluation };
