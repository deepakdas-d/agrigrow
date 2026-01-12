import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:agrigrow/core/constants/app_colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class ChatMessage {
  final String? text;
  final File? image;
  final bool isUser;
  final String time;
  final String? type; // 'text' or 'image'

  ChatMessage({
    this.text,
    this.image,
    required this.isUser,
    required this.time,
    this.type = 'text',
  });
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Mock Data matching the UI
  final List<dynamic> _chatHistory = [
    // Using a simple Map or String for Date Separators in a mixed list,
    // but for cleaner state, I'll use a specific logic in ListView.builder or a list of abstract items.
    // Let's stick to a mixed list for simplicity in this file.
    "Yesterday",
    ChatMessage(
      text: "What is the correct time for plough?",
      isUser: true,
      time: "09:25 AM",
    ),
    ChatMessage(
      text:
          "The best time to plough a rice field is 2 to 3 weeks before transplanting.\nThe Key Requirements:\n• Water Condition: For most rice (wetland paddy), the field should be flooded or saturated with about 2–5 cm of water. This makes the soil soft enough to create a 'muddy' consistency.",
      isUser: false,
      time: "09:26 AM",
    ),
    "Today",
    1, // 1 int identifier for the Asset Message Mock
  ];

  @override
  void initState() {
    super.initState();
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _chatHistory.add(
        ChatMessage(
          text: _controller.text,
          isUser: true,
          time: _formatTime(DateTime.now()),
        ),
      );
      _controller.clear();
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _chatHistory.add(
          ChatMessage(
            image: File(pickedFile.path),
            isUser: true,
            time: _formatTime(DateTime.now()),
            type: 'image',
          ),
        );
      });
    }
  }

  String _formatTime(DateTime dt) {
    // Simple formatter for demo
    String hour = dt.hour > 12 ? '${dt.hour - 12}' : '${dt.hour}';
    hour = dt.hour == 0 ? '12' : hour;
    String minute = dt.minute.toString().padLeft(2, '0');
    String ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'TALK TO ARGIBOT',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final item = _chatHistory[index];
                if (item is String) {
                  return _buildDateSeparator(item);
                } else if (item is int) {
                  return _buildAssetImageMessage();
                } else if (item is ChatMessage) {
                  return _buildMessageBubble(item);
                }
                return const SizedBox.shrink(); // Fallback
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isUser = message.isUser;

    final Alignment alignment = isUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    final Color bubbleColor = isUser
        ? AppColors.primaryGreen
        : const Color(0xFFE8F2EC);

    final Color textColor = isUser ? Colors.white : Colors.black87;

    final BorderRadius borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
      bottomRight: isUser
          ? const Radius.circular(4)
          : const Radius.circular(18),
    );

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              const CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primaryGreen,
                child: Icon(Icons.smart_toy, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 6),
            ],
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: borderRadius,
              ),
              child: message.type == 'image'
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        message.image!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(
                      message.text ?? '',
                      style: TextStyle(color: textColor),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Widget for the Asset Image Mock
  Widget _buildAssetImageMessage() {
    // Hardcoded Mock for the 3rd item in chat
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(10), // Reduced header padding for image
          decoration: BoxDecoration(
            color: AppColors
                .primaryGreen, // Grey bubble for the image one? Image shows grey background.
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.zero,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/rice-plantation.jpg',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(
                    height: 120,
                    color: Colors.grey,
                    child: const Center(child: Text('Image Placeholder')),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'what is the isuue ?',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4, bottom: 10),
          child: Text(
            "10:26 AM",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type message here...",
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.black54),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
