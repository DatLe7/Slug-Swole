import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key}); // Add the key parameter

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userInput = TextEditingController();

  static const apiKey = "AIzaSyCfztqK6EtTQpahbW1zFII1lm4TvjB2YNU";

  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);

  final List<Message> _messages = [];

  @override
  void dispose() {
    _userInput.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final message = _userInput.text;

    if (message.isEmpty) return;

    _addUserMessage(message);
    _userInput.clear();

    final response = await _generateBotResponse(message);
    _addBotMessage(response.text ?? "No response available.");
  }

  void _addUserMessage(String message) {
    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add(Message(isUser: false, message: message, date: DateTime.now()));
    });
  }

  Future<GenerateContentResponse> _generateBotResponse(String message) {
    final content = [Content.text(message)];
    return model.generateContent(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white), // Circular "X" icon
          onPressed: () {
          Navigator.pop(context); // Exit back to the homepage
            },
          tooltip: 'Close Chat',
        ),
        title: const Text(
          "Chat with a Bot!", // Add the text here
          style: TextStyle(color: Colors.white, fontSize: 18), // Optional styling
        ),
        backgroundColor: Colors.red, // Optional: Set the AppBar color to match the theme
        elevation: 0, // Optional: Remove shadow for a flat AppBar
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Set the background color to white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                  );
                },
              ),
            ),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 15,
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: _userInput,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                label: const Text('Enter Your Message'),
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            padding: const EdgeInsets.all(12),
            iconSize: 30,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all(const CircleBorder()),
            ),
            onPressed: sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  BorderRadius _getBorderRadius(bool isUser) {
    return BorderRadius.only(
      topLeft: const Radius.circular(10),
      bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
      topRight: const Radius.circular(10),
      bottomRight: isUser ? Radius.zero : const Radius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
        color: isUser ? Colors.blueAccent : Colors.grey.shade400,
        borderRadius: _getBorderRadius(isUser),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16, color: isUser ? Colors.white : Colors.black),
          ),
          Text(
            date,
            style: TextStyle(fontSize: 10, color: isUser ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}