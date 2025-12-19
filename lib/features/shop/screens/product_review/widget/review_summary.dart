import 'package:flutter/material.dart';

class ReviewSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> starDistribution;

  const ReviewSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.starDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // --- Cột điểm trung bình ---
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'trên 5',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                '$totalReviews đánh giá',
                style: const TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // --- Biểu đồ tỷ lệ sao ---
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                int star = 5 - index;
                int count = starDistribution[star] ?? 0;
                double percent =
                    totalReviews > 0 ? count / totalReviews : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('$star★',
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.amber,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${(percent * 100).toInt()}%',
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
