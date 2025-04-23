const SpecialistService = require('./SpecialistService');

async function getAssignedChildren(req, res) {
  try {
    const { specialist_id } = req.query;
    console.log("🔹 Buscando niños para specialist_id:", specialist_id);

    if (!specialist_id) {
      return res.status(400).json({ message: "Se requiere el ID del especialista." });
    }

    const children = await SpecialistService.getChildrenBySpecialist(specialist_id);
    res.json(children);
  } catch (error) {
    console.error("❌ Error en getAssignedChildren:", error);
    res.status(500).json({ message: "Error interno en el servidor." });
  }
}

async function getSpecialistStats(req, res) {
  try {
    const { specialist_id } = req.query;

    if (!specialist_id) {
      return res.status(400).json({ message: "Se requiere el ID del especialista." });
    }

    const stats = await SpecialistService.getSpecialistStats(specialist_id);
    res.json(stats);
  } catch (error) {
    console.error("❌ Error en getSpecialistStats:", error);
    res.status(500).json({ message: "Error interno en el servidor." });
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
async function getChildReport(req, res) {
  const { child_id } = req.query;

  try {
    if (!child_id) {
      return res.status(400).json({ message: "Se requiere el ID del niño." });
    }

    const report = await pool.query(`
      SELECT nombre, ultima_conexion, progreso 
      FROM ninos WHERE child_id = $1
    `, [child_id]);

    res.json(report.rows[0]);
  } catch (error) {
    console.error("❌ Error en getChildReport:", error);
    res.status(500).json({ message: "Error interno en el servidor." });
  }
}

async function getChildReportFromDB(req, res) {
  const { nino_id } = req.query;

  try {
    if (!nino_id) {
      return res.status(400).json({ message: "Se requiere el ID del niño." });
    }

    const report = await pool.query(`
      SELECT progreso_json, certificado, fecha 
      FROM reportes WHERE nino_id = $1
    `, [nino_id]);

    res.json(report.rows[0]);
  } catch (error) {
    console.error("❌ Error en getChildReportFromDB:", error);
    res.status(500).json({ message: "Error interno en el servidor." });
  }
}

async function getParentsBySpecialist(req, res) {
  const { specialist_id } = req.query;

  try {
    if (!specialist_id) {
      return res.status(400).json({ message: "Se requiere el ID del especialista." });
    }

    const parents = await pool.query(`
      SELECT u.id, u.nombre, u.email,
      json_agg(json_build_object('id', n.id, 'nombre', n.nombre, 'ultimaConexion', n.ultima_conexion)) AS children
      FROM usuarios u
      LEFT JOIN ninos n ON u.id = n.padre_id
      WHERE u.tipo_usuario = 'padre'
      GROUP BY u.id
    `, []);

    res.json(parents.rows);
  } catch (error) {
    console.error("❌ Error en getParentsBySpecialist:", error);
    res.status(500).json({ message: "Error interno en el servidor." });
  }
}


module.exports = {
  getAssignedChildren,
  getSpecialistStats,
  getChildReportFromDB,
  sendEvaluation
};

