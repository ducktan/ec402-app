const express = require('express');
const router = express.Router();
const { GoogleGenerativeAI } = require('@google/generative-ai');

// Khởi tạo Gemini AI
const genAI = new GoogleGenerativeAI("API_KEY");
const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });

// Lưu lịch sử chat cho mỗi session
const chatSessions = new Map();

// Route để gửi message
// Route đơn giản không cần session (one-shot)
router.post('/', async (req, res) => {
  try {
    const { prompt } = req.body;

    if (!prompt) {
      return res.status(400).json({ error: 'Prompt là bắt buộc' });
    }

    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    res.json({ reply: text });

  } catch (error) {
    console.error('Lỗi:', error);
    res.status(500).json({ 
      error: 'Có lỗi xảy ra',
      details: error.message 
    });
  }
});
module.exports = router;