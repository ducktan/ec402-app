import 'package:flutter/material.dart';
import 'package:ec402_app/services/ai_chat_service.dart';

class AiChatPopup extends StatefulWidget {
  const AiChatPopup({super.key});

  @override
  State<AiChatPopup> createState() => _AiChatPopupState();
}

class _AiChatPopupState extends State<AiChatPopup> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  String? reply;

  Future<void> send() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      isLoading = true;
      reply = null;
    });

    try {
      final res = await AiChatService.sendPrompt(_controller.text);
      print("res là: $res"); 
      setState(() {
        reply = res;
      });
    } catch (e) {
      setState(() {
        reply = 'Có lỗi xảy ra 😢';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🤖 Trợ lý mua sắm'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Hỏi gì đó về sản phẩm...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (isLoading) const CircularProgressIndicator(),
            if (reply != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(reply!),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
        ElevatedButton(
          onPressed: send,
          child: const Text('Gửi'),
        ),
      ],
    );
  }
}
