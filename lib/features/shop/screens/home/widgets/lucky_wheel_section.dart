import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ec402_app/services/game_service.dart';

class LuckyWheelSection extends StatefulWidget {
  const LuckyWheelSection({super.key});

  @override
  State<LuckyWheelSection> createState() => _LuckyWheelSectionState();
}

class _LuckyWheelSectionState extends State<LuckyWheelSection> {
  final StreamController<int> selected = BehaviorSubject<int>();
  bool isSpinning = false;
  int _resultIndex = 0;

  final items = [
    'Voucher 10k',
    'Mất lượt',
    'Voucher 50k',
    'Xu 500',
    'Free Ship',
    'Chúc may mắn',
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void _spin() async {
    if (isSpinning) return;
    setState(() => isSpinning = true);

    try {
      final result = await GameService.spinWheel();
      _resultIndex = result['index'];
      selected.add(_resultIndex);
    } catch (e) {
      setState(() => isSpinning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface, // trắng
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ===== HEADER =====
          Row(
            children: [
              const Icon(Icons.card_giftcard, color: Color(0xFFFF6B00)),
              const SizedBox(width: 8),
              Text(
                'Vòng Quay May Mắn',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===== WHEEL =====
          SizedBox(
            height: 220,
            child: FortuneWheel(
              selected: selected.stream,
              animateFirst: false,
              indicators: const [
                FortuneIndicator(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 40,
                    color: Color(0xFFFF6B00),
                  ),
                ),
              ],
              items: [
                for (var it in items)
                  FortuneItem(
                    child: Text(
                      it,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B2B2B),
                      ),
                    ),
                    style: FortuneItemStyle(
                      color: items.indexOf(it) % 2 == 0
                          ? const Color(0xFFFFF3E8) // cam nhạt
                          : const Color(0xFFFFE0C2),
                      borderColor: colorScheme.primary,
                      borderWidth: 1.5,
                    ),
                  ),
              ],
              onAnimationEnd: () {
                setState(() => isSpinning = false);

                final reward = items[_resultIndex];
                final isBad =
                    reward == 'Mất lượt' || reward == 'Chúc may mắn';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: isBad
                        ? Colors.grey.shade700
                        : colorScheme.primary,
                    content: Text(
                      isBad
                          ? 'Chưa may mắn rồi 😢'
                          : 'Bạn nhận được: $reward 🎉',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ===== BUTTON =====
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSpinning ? null : _spin,
              child: Text(
                isSpinning ? 'Đang quay...' : 'QUAY NGAY',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
