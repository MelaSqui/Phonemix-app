const UserService = require('./userService');

const UserController = {
    async register(req, res) {
        try {
            const user = await UserService.register(req.body);
            res.status(201).json(user);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async login(req, res) {
        try {
            const token = await UserService.login(req.body);
            res.status(200).json({ token });
        } catch (error) {
            res.status(401).json({ error: error.message });
        }
    },
};

module.exports = UserController;
