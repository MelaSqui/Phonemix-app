const bcrypt = require('bcrypt');
const jwt = require('../../shared/JWTHandler');
const UserModel = require('./userModel');

const UserService = {
    async register(data) {
        const hashedPassword = await bcrypt.hash(data.password, 10);
        return UserModel.create({ ...data, password: hashedPassword });
    },

    async login(data) {
        const user = await UserModel.findByEmail(data.email);
        if (!user) throw new Error('Usuario no encontrado');

        const isPasswordValid = await bcrypt.compare(data.password, user.password);
        if (!isPasswordValid) throw new Error('Contraseña incorrecta');

        return jwt.generate({ id: user.id, email: user.email });
    },
};

module.exports = UserService;
