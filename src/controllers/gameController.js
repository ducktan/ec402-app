const db = require('../config/db');

// Cấu hình phần thưởng và tỷ lệ trúng (Tổng xác suất nên là 100%)
// Index phải khớp với thứ tự hiển thị trên vòng quay ở Flutter
const REWARDS = [
    { index: 0, label: 'Voucher 10k', type: 'voucher', value: 10000, probability: 0.1 }, // 10%
    { index: 1, label: 'Mất lượt', type: 'miss', value: 0, probability: 0.2 },          // 20%
    { index: 2, label: 'Voucher 50k', type: 'voucher', value: 50000, probability: 0.05 }, // 5%
    { index: 3, label: 'Xu 500', type: 'coin', value: 500, probability: 0.15 },         // 15% (Cần thêm cột xu vào user nếu muốn dùng thật)
    { index: 4, label: 'Free Ship', type: 'voucher', value: 30000, probability: 0.1 },  // 10% (Giả sử free ship trị giá 30k)
    { index: 5, label: 'Chúc may mắn', type: 'miss', value: 0, probability: 0.4 },      // 40%
];

exports.spinWheel = async (req, res) => {
    const userId = req.user.id; // Lấy từ middleware authen

    try {
        // 1. Kiểm tra xem hôm nay đã quay chưa
        const [users] = await db.execute('SELECT last_spin_time FROM users WHERE id = ?', [userId]);
        const lastSpin = users[0].last_spin_time ? new Date(users[0].last_spin_time) : null;
        const today = new Date();

        // --- BẮT ĐẦU SỬA ---
        /* if (lastSpin && lastSpin.toDateString() === today.toDateString()) {
            return res.status(400).json({ message: 'Bạn đã quay hôm nay rồi, vui lòng quay lại vào ngày mai!' });
        }
        */
        // --- KẾT THÚC SỬA ---


        // 2. Thuật toán chọn quà dựa trên xác suất (Weighted Random)

        let random = Math.random();
        let selectedReward = null;
        let cumulativeProbability = 0;

        for (let reward of REWARDS) {
            cumulativeProbability += reward.probability;
            if (random <= cumulativeProbability) {
                selectedReward = reward;
                break;
            }
        }

        // Fallback nếu có lỗi làm tròn số
        if (!selectedReward) selectedReward = REWARDS[REWARDS.length - 1];

        // 3. Xử lý phần thưởng
        if (selectedReward.type === 'voucher') {
            // Tạo mã voucher ngẫu nhiên
            const code = `LUCKY-${Date.now()}`;
            await db.execute(
                `INSERT INTO user_vouchers (user_id, code, description, discount_value, expires_at) 
                 VALUES (?, ?, ?, ?, DATE_ADD(NOW(), INTERVAL 7 DAY))`,
                [userId, code, 'Quà tặng vòng quay may mắn', selectedReward.value]
            );
        }
        // Nếu là 'coin' thì update bảng users (nếu bạn có cột xu), hiện tại mình bỏ qua logic này

        // 4. Cập nhật thời gian quay
        await db.execute('UPDATE users SET last_spin_time = NOW() WHERE id = ?', [userId]);

        // 5. Trả về kết quả cho Flutter (QUAN TRỌNG: Trả về index để vòng quay dừng đúng chỗ)
        res.json({
            success: true,
            reward: selectedReward,
            index: selectedReward.index
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Lỗi server' });
    }
};