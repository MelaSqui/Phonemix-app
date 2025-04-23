const pool = require("./config/db"); // Asegúrate de que la ruta sea correcta
const bcrypt = require("bcryptjs");

async function encryptAndStorePasswords() {
    try {
        // Recuperar todos los usuarios de la base de datos
        const users = await pool.query("SELECT id, password FROM users");
        
        // Iterar sobre cada usuario y encriptar su contraseña
        for (let user of users.rows) {
            const hashedPassword = await bcrypt.hash(user.password, 10);
            await pool.query("UPDATE users SET password = $1 WHERE id = $2", [hashedPassword, user.id]);
        }

        // Recuperar todos los niños de la base de datos
        const children = await pool.query("SELECT id, password FROM children");
        
        // Iterar sobre cada niño y encriptar su contraseña
        for (let child of children.rows) {
            const hashedPassword = await bcrypt.hash(child.password, 10);
            await pool.query("UPDATE children SET password = $1 WHERE id = $2", [hashedPassword, child.id]);
        }

        console.log("Todas las contraseñas se han encriptado y actualizado con éxito.");
    } catch (error) {
        console.error("Error encriptando y actualizando contraseñas:", error);
    }
}

encryptAndStorePasswords();
