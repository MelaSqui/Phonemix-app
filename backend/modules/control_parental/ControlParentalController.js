const ControlParentalService = require('./ControlParentalService');

async function getChildren(req, res) {
  try {
    const { padre_id } = req.query;
    console.log("Solicitud recibida con padre_id:", padre_id);

    if (!padre_id) {
      return res.status(400).json({ message: "Se requiere el ID del padre." });
    }

    const childrenData = await ControlParentalService.getChildrenByParent(padre_id);
    res.json(childrenData);
  } catch (error) {
    console.error("❌ Error en getChildren:", error);
    res.status(500).json({ message: error.message });
  }
}

async function getRecentMessages(req, res) {
  try {
    const { padre_id } = req.query;
    console.log("Solicitud de mensajes con padre_id:", padre_id);

    if (!padre_id) {
      return res.status(400).json({ message: "Se requiere el ID del padre." });
    }

    const messagesData = await ControlParentalService.getMessagesByParent(padre_id);
    res.json(messagesData);
  } catch (error) {
    console.error("❌ Error en getRecentMessages:", error);
    res.status(500).json({ message: error.message });
  }
}

module.exports = { getChildren, getRecentMessages };
