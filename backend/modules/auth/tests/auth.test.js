const request = require("supertest");
const app = require("../../../server");
const { closePool } = require("../../../shared/Database");

describe("Pruebas Unitarias - Autenticación", () => {

  test("✅ POST /auth/login - Debe permitir a un usuario iniciar sesión", async () => {
    const response = await request(app)
      .post("/auth/login")
      .send({
        email: "carlos.lopez@example.com",
        password: "12345"
      });

    console.log("🔹 Respuesta del servidor (Usuario):", response.body);

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty("token"); 
  });

  test("✅ POST /auth/login-child - Debe permitir a un niño iniciar sesión con PIN", async () => {
    const response = await request(app)
      .post("/auth/login-child")
      .send({
        pin: "123456"
      });

    console.log("🔹 Respuesta del servidor (Niño):", response.body); //

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty("token"); // 
  });

  afterAll(async () => {
    await closePool();
  });

});
