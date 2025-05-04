const request = require("supertest");
const app = require("../../../server");
const { closePool } = require("../../../shared/Database");

describe("Pruebas Unitarias - Specialist Reports API", () => {

  test("✅ POST /specialist/reports - Debe permitir al especialista crear un reporte", async () => {
    const nuevoReporte = {
      specialist_id: 1, // 🔥 ID manual para pruebas
      padre_id: 1,
      nino_id: 1,
      actividad_id: 2,
      progreso_json: JSON.stringify({ avance: 80, intentos: 3 }),
      comentario: "Reporte de prueba",
      fecha: "2025-05-03",
      certificado: false 
    };

    const response = await request(app)
      .post("/specialist/reports")
      .send(nuevoReporte);

    console.log("🔹 Respuesta del servidor:", response.body);

    expect(response.statusCode).toBe(200); // 🔥 Ajustado según el backend
    expect(response.body).toHaveProperty("id"); // 🔥 Verificamos que el reporte se haya creado correctamente
    expect(response.body).toHaveProperty("actividad_id");
    expect(response.body).toHaveProperty("comentario");
  });

  test("✅ GET /specialist/reports/specialist - Debe obtener los reportes de un especialista", async () => {
    const response = await request(app)
      .get("/specialist/reports/specialist?specialist_id=1");

    console.log("🔹 Respuesta del servidor:", response.body);

    expect(response.statusCode).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
  });

  test("✅ GET /specialist/reports/parent - Debe obtener los reportes de un padre", async () => {
    const response = await request(app)
      .get("/specialist/reports/parent?padre_id=1") 

    console.log("🔹 Respuesta del servidor:", response.body);

    expect(response.statusCode).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
  });

  test("✅ GET /specialist/reports/child - Debe obtener los reportes de un niño", async () => {
    const response = await request(app)
      .get("/specialist/reports/child?nino_id=1"); 

    console.log("🔹 Respuesta del servidor:", response.body);

    expect(response.statusCode).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
  });

});

afterAll(async () => {
  await closePool();
  console.log("✅ Conexión a la base de datos cerrada.");
});
