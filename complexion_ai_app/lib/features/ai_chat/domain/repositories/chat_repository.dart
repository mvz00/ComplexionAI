import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<ChatMessage> sendMessage(String conversationId, String content, {String? imagePath});
  Future<List<ChatMessage>> getMessages(String conversationId);
  Future<String> createConversation(String userId);
}
