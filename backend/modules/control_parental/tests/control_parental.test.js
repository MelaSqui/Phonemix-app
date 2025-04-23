const request = require("supertest");
const app = require("../../../server");
const { closePool } = require("../../../shared/Database");

describe("Pruebas Unitarias - Control Parental", () => {

  test("✅ GET /control-parental/children - Debe retornar niños asociados al padre", async () => {
    const response = await request(app).get("/control-parental/children?padre_id=1");

    console.log("🔹 Respuesta del servidor (Niños):", response.body);

    expect(response.statusCode).toBe(200);
    expect(response.body).toBeInstanceOf(Array); 
    expect(response.body.length).toBeGreaterThan(0); 
  });

  test("✅ GET /control-parental/mensajes-especialista - Debe retornar mensajes del especialista al padre", async () => {
    const response = await request(app).get("/control-parental/mensajes-especialista?padre_id=1");
  
    console.log("🔹 Status Code:", response.statusCode);
    console.log("🔹 Respuesta completa:", response.body);
  
    expect(response.statusCode).toBe(200);
    expect(response.body).toBeInstanceOf(Array);
    expect(response.body.length).toBeGreaterThan(0);
  });

  afterAll(async () => {
    await closePool();
  });

});
