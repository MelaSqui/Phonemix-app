const request = require("supertest");
const app = require("../../../server");
const { closePool } = require("../../../shared/Database");

describe("Pruebas Unitarias - Specialist API", () => {

  test("✅ POST /specialist/evaluation - Debe permitir al especialista enviar una evaluación", async () => {
    const response = await request(app)
      .post("/specialist/evaluation")
      .send({
        specialist_id: 1,
        padre_id: 1,
        mensaje: "El niño ha mejorado en la pronunciación."
      });

    console.log("🔹 Respuesta del servidor:", response.body); 

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty("message", "✅ Evaluación enviada correctamente.");
  });

  afterAll(async () => {
    await closePool();
  });

});
