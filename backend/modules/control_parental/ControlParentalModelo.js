class ControlParental {
  constructor(id, padre_id, child_id, progress, hora_inicio, hora_fin, restricciones, activo, fecha_registro) {
    this.id = id;
    this.padre_id = padre_id; // Clave foránea correcta
    this.child_id = child_id; // Identificador del niño
    this.progress = progress; // Tiempo total de actividad en minutos
    this.hora_inicio = hora_inicio; // Hora de inicio permitida
    this.hora_fin = hora_fin; // Hora de fin permitida
    this.restricciones = restricciones; // Configuración de restricciones en JSON
    this.activo = activo; // Estado de actividad (true/false)
    this.fecha_registro = fecha_registro; // Fecha de registro en la tabla
  }

  static fromJSON(data) {
    return new ControlParental(
      data.id,
      data.padre_id,  // Uso correcto de `padre_id`
      data.child_id,
      data.progress,
      data.hora_inicio,
      data.hora_fin,
      JSON.parse(data.restricciones), // Convertir restricciones a objeto JSON
      data.activo,
      data.fecha_registro
    );
  }
}

module.exports = ControlParental;
