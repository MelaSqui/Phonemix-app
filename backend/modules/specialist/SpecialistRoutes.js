const express = require("express");
const SpecialistController = require("./SpecialistController");

const router = express.Router();

router.post("/reports", SpecialistController.createReport);
router.get("/reports/specialist", SpecialistController.getReportsBySpecialist);
router.get("/reports/parent", SpecialistController.getReportsByParent);
router.get("/reports/child", SpecialistController.getReportsByChild);
router.post('/evaluation', SpecialistController.sendEvaluation);

// rutas de familias
router.get("/users", SpecialistController.getUsersWithChildren);

module.exports = router;
