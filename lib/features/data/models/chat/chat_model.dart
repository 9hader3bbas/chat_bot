class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError; // Optional: To indicate if it's an error message

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });
}
