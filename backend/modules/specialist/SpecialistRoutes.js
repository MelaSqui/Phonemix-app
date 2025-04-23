const express = require('express');
const router = express.Router();
const SpecialistController = require('./SpecialistController'); 

router.get('/children', SpecialistController.getAssignedChildren);
router.get('/stats', SpecialistController.getSpecialistStats);
router.get('/child-report', SpecialistController.getChildReportFromDB);
router.post('/evaluation', SpecialistController.sendEvaluation);

module.exports = router;
