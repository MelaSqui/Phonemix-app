const express = require("express");
const cors = require("cors");
const authRoutes = require("./modules/auth/authRoutes");
const controlParentalRoutes = require("./modules/control_parental/ControlParentalRoutes");
const specialistRoutes = require("./modules/specialist/SpecialistRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/auth", authRoutes);
app.use("/control-parental", controlParentalRoutes);
app.use("/specialist", specialistRoutes);

// 🔹 Solo inicia el servidor si NO está en modo test
if (process.env.NODE_ENV !== "test") {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`✅ Servidor corriendo en el puerto ${PORT}`);
  });
}

module.exports = app; // ✅ Exporta `app` sin iniciar el servidor
