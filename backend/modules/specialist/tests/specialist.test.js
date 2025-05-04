const request = require("supertest");
const app = require("../../../server");
const { closePool } = require("../../../shared/Database");

describe("Pruebas Unitarias - Specialist Users API", () => {

  test("✅ GET /specialist/users - Debe obtener usuarios con niños registrados", async () => {
    const response = await request(app)
      .get("/specialist/users?specialist_id=1") // 🔥 Ahora incluye el `specialist_id` requerido
      .set("Authorization", `Bearer "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsdWlzLnBlcmV6QGV4YW1wbGUuY29tIiwiaWF0IjoxNzQ2Mjk5NTA1LCJleHAiOjE3NDYzMDMxMDV9.-XpTUwhgBg028RMEdKn8NNJyWeos3wihnF9UOO9iJKQ`); // 🔥 Asegúrate de usar un token válido si es necesario

    console.log("🔹 Respuesta del servidor:", response.body);

    expect(response.statusCode).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
    expect(response.body.length).toBeGreaterThan(0); // 🔥 Verificamos que la lista no esté vacía
    expect(response.body[0]).toHaveProperty("user_id"); // 🔥 Ajustado para coincidir con los campos del controlador
    expect(response.body[0]).toHaveProperty("user_name");
    expect(response.body[0]).toHaveProperty("children"); // 🔥 Verifica que el usuario tenga niños asociados
  });

});

afterAll(async () => {
  await closePool();
  console.log("✅ Conexión a la base de datos cerrada.");
});
