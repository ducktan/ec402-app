import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../services/game_service.dart';

class LuckyWheelScreen extends StatefulWidget {
  const LuckyWheelScreen({Key? key}) : super(key: key);

  @override
  State<LuckyWheelScreen> createState() => _LuckyWheelScreenState();
}

class _LuckyWheelScreenState extends State<LuckyWheelScreen> {
  // Stream controller quản lý vị trí dừng
  final StreamController<int> selected = BehaviorSubject<int>();

  // Biến để lưu chỉ số ô trúng thưởng hiện tại
  int _resultIndex = 0;

  // Danh sách quà
  final items = <String>[
    'Voucher 10k', // 0
    'Mất lượt', // 1 (Bad)
    'Voucher 50k', // 2
    'Xu 500', // 3
    'Free Ship', // 4
    'Chúc may mắn', // 5 (Bad)
  ];

  bool isSpinning = false;

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void _handleSpin() async {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
    });

    try {
      // 1. Gọi API
      final result = await GameService.spinWheel();

      // 2. Lấy index từ kết quả trả về
      int serverIndex = result['index'];

      // Lưu lại index để dùng lúc hiển thị thông báo
      _resultIndex = serverIndex;

      // 3. Ra lệnh cho vòng quay
      selected.add(serverIndex);
    } catch (e) {
      setState(() {
        isSpinning = false;
      });
      // Hiện thông báo lỗi nếu gọi API thất bại
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Lỗi"),
          content: Text(e.toString().replaceAll("Exception: ", "")),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A35C9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Vòng Quay May Mắn',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'QUAY LÀ CÓ QUÀ!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              height: 350,
              child: FortuneWheel(
                selected: selected.stream,
                animateFirst: false,
                items: [
                  for (var it in items)
                    FortuneItem(
                      child: Text(
                        it,
                        // --- UPDATE 1: Đổi màu chữ thành đen ---
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: FortuneItemStyle(
                        color: items.indexOf(it) % 2 == 0
                            ? const Color(0xFFFFD700)
                            : const Color(0xFFFFFACD),
                        borderColor: Colors.deepPurple,
                        borderWidth: 2,
                      ),
                    ),
                ],
                // Sự kiện khi quay xong
                onAnimationEnd: () {
                  setState(() {
                    isSpinning = false;
                  });

                  // --- UPDATE 2: Logic kiểm tra kết quả ---
                  final rewardName = items[_resultIndex];
                  // Kiểm tra xem có phải ô xui xẻo không
                  final bool isBadLuck =
                      rewardName == 'Mất lượt' || rewardName == 'Chúc may mắn';

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Column(
                        children: [
                          Icon(
                            // Đổi icon tùy theo kết quả
                            isBadLuck
                                ? Icons.sentiment_dissatisfied
                                : Icons.emoji_events,
                            color: isBadLuck ? Colors.grey : Colors.amber,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            // Đổi tiêu đề tùy theo kết quả
                            isBadLuck ? "Rất Tiếc!" : "Chúc Mừng!",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      content: Text(
                        // Đổi nội dung thông báo
                        isBadLuck
                            ? "Bạn chưa may mắn lần này. Hãy thử lại nhé!"
                            : "Bạn đã nhận được: $rewardName",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Thử lại"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Về Trang Chủ"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: isSpinning ? null : _handleSpin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isSpinning ? 'Đang quay...' : 'QUAY NGAY',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
