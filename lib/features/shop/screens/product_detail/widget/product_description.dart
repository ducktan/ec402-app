import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mô tả sản phẩm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Đôi giày thể thao Nike phiên bản mới nhất với thiết kế năng động và '
            'chất liệu cao cấp, mang lại cảm giác thoải mái khi vận động. '
            'Phù hợp cho cả luyện tập thể thao và phong cách thường ngày.\n\n'
            'Đặc điểm nổi bật:\n'
            '• Chất liệu vải mesh thoáng khí\n'
            '• Đế cao su chống trơn trượt\n'
            '• Trọng lượng nhẹ, dễ di chuyển\n'
            '• Màu sắc thời trang, dễ phối đồ',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
