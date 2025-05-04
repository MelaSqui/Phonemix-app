const SpecialistModel = require("./SpecialistModel");

const SpecialistService = {
  async createReport(specialist_id, padre_id, nino_id, actividad_id, progreso_json, comentario) {
    if (!specialist_id || !padre_id || !nino_id || !actividad_id || !progreso_json) {
      throw new Error("❌ Todos los campos son obligatorios.");
    }
    return await SpecialistModel.createReport(specialist_id, padre_id, nino_id, actividad_id, progreso_json, comentario);
  },

  async getReportsBySpecialist(specialist_id) {
    if (!specialist_id) {
      throw new Error("❌ Se requiere specialist_id.");
    }
    return await SpecialistModel.getReportsBySpecialist(specialist_id);
  },

  async getReportsByParent(padre_id) {
    if (!padre_id) {
      throw new Error("❌ Se requiere padre_id.");
    }
    return await SpecialistModel.getReportsByParent(padre_id);
  },

  async getReportsByChild(nino_id) {
    if (!nino_id) {
      throw new Error("❌ Se requiere nino_id.");
    }
    return await SpecialistModel.getReportsByChild(nino_id);
  },
  async sendEvaluation(specialist_id, padre_id, mensaje) {
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
};

module.exports = SpecialistService;
