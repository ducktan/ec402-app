import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ReviewItem extends StatelessWidget {
  final String userName;
  final String comment;
  final int rating;
  final String date;
  final String? avatarUrl;
  final List<String> imageUrls;
  final VoidCallback? onDelete; // callback xóa
  final VoidCallback? onEdit; // callback sửa

  const ReviewItem({
    super.key,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
    this.avatarUrl,
    required this.imageUrls,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null ? const Icon(Iconsax.user) : null,
              ),
              const SizedBox(width: 8),
              Text(userName, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Iconsax.edit_2, color: Colors.blue),
                  tooltip: 'Chỉnh sửa đánh giá',
                ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Iconsax.trash, color: Colors.red),
                  tooltip: 'Xóa đánh giá',
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(comment),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
