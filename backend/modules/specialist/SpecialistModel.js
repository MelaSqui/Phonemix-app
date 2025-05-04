const { pool } = require("../../shared/Database");

const SpecialistModel = {
  async createReport(specialist_id, padre_id, nino_id, actividad_id, progreso_json, comentario) {
    const result = await pool.query(
      "INSERT INTO reportes (especialista_id, padre_id, nino_id, actividad_id, progreso_json, comentario, fecha, certificado) VALUES ($1, $2, $3, $4, $5, $6, NOW(), FALSE) RETURNING *",
      [specialist_id, padre_id, nino_id, actividad_id, progreso_json, comentario]
    );
    return result.rows[0];
  },

  async getReportsBySpecialist(specialist_id) {
    const result = await pool.query(`
      SELECT r.id AS report_id, r.padre_id, r.nino_id, r.actividad_id, r.progreso_json, r.comentario, r.fecha 
      FROM reportes r
      JOIN ninos n ON r.nino_id = n.id
      WHERE n.especialista_id = $1
      ORDER BY r.fecha DESC;
    `, [specialist_id]);
  
    return result.rows;
  },

  async getReportsByParent(padre_id) {
    const result = await pool.query(`
      SELECT r.id AS report_id, r.padre_id, r.nino_id, r.actividad_id, r.progreso_json, r.comentario, r.fecha 
      FROM reportes r
      WHERE r.padre_id = $1
      ORDER BY r.fecha DESC;
    `, [padre_id]);
  
    return result.rows;
  },

  async getReportsByChild(nino_id) {
    const result = await pool.query(
      `SELECT r.*, a.actividad_id, a.estado, a.porcentaje_avance, a.tiempo_total_minutos, a.intentos 
       FROM reportes r 
       JOIN avance_actividades a ON r.nino_id = a.nino_id 
       WHERE r.nino_id = $1 
       ORDER BY r.fecha DESC`,
      [nino_id]
    );
    return result.rows;
  }  
};
module.exports = SpecialistModel;