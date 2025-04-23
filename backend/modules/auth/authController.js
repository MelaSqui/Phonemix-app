const bcrypt = require('bcrypt');
const jwt = require('../../shared/JWTHandler'); // Ruta al manejador de JWT
const { pool } = require("../../shared/Database"); 
const request = require("supertest");
const app = require("../../server"); // ✅ Debe importar `app`, NO iniciar el servidor


const AuthController = {
  async login(req, res) {
    const { email, password } = req.body;
  
    try {
      if (!email || !password) {
        return res.status(400).json({ message: 'Email y contraseña son requeridos.' });
      }
  
      // 🔹 Buscar el usuario y devolver `id` en lugar de `padre_id`
      const userResult = await pool.query('SELECT id, email, password FROM usuarios WHERE email = $1', [email]);
  
      if (userResult.rows.length > 0) {
        const user = userResult.rows[0];
        const isPasswordValid = await bcrypt.compare(password, user.password);
  
        if (isPasswordValid) {
          const token = jwt.generate({ id: user.id, email: user.email });
  
          return res.status(200).json({ 
            token, 
            message: 'Login exitoso', 
            type: 'usuario',
            padre_id: user.id  // 🔹 Usamos `id` del usuario como identificador del padre
          });
        } else {
          return res.status(401).json({ message: 'Contraseña incorrecta.' });
        }
      }
  
      // 🔹 Buscar en la tabla de especialistas
      const specialistResult = await pool.query('SELECT id, email, password FROM especialistas WHERE email = $1', [email]);
  
      if (specialistResult.rows.length > 0) {
        const specialist = specialistResult.rows[0];
        const isPasswordValid = await bcrypt.compare(password, specialist.password);
  
        if (isPasswordValid) {
          const token = jwt.generate({ id: specialist.id, email: specialist.email });
  
          return res.status(200).json({ 
            token, 
            message: 'Login exitoso', 
            type: 'especialista' 
          });
        } else {
          return res.status(401).json({ message: 'Contraseña incorrecta.' });
        }
      }
  
      return res.status(404).json({ message: 'Usuario no encontrado.' });
  
    } catch (error) {
      console.error('Error en el login:', error.message);
      return res.status(500).json({ message: 'Error interno del servidor.' });
    }
  },
  

  // Método actualizado para el login de niños
  async loginChild(req, res) {
    const { pin } = req.body;

    try {
      if (!pin) {
        return res.status(400).json({ message: 'El PIN es requerido.' });
      }

      // Buscar en la tabla de niños usando el PIN
      console.log('PIN recibido para niño:', pin); // Log para depuración
      const childResult = await pool.query('SELECT * FROM ninos WHERE pin = $1', [pin]);
      console.log('Resultado de la consulta niños:', childResult.rows); // Log para depuración

      if (childResult.rows.length > 0) {
        const child = childResult.rows[0];
        const token = jwt.generate({ id: child.id, nombre: child.nombre });
        return res.status(200).json({ token, message: 'Login exitoso', type: 'nino' });
      }

      return res.status(404).json({ message: 'PIN incorrecto.' });
    } catch (error) {
      console.error('Error en el login de niños:', error.message);
      return res.status(500).json({ message: 'Error interno del servidor.' });
    }
  },
};

module.exports = AuthController;
