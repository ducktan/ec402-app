const express = require('express');
const router = express.Router();
const gameController = require('../controllers/gameController');
const { verifyToken } = require('../middlewares/auth.middleware'); 

router.post('/spin', verifyToken, gameController.spinWheel);

module.exports = router;