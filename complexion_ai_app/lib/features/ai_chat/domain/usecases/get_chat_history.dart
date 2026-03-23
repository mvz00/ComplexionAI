import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatHistory {
  final ChatRepository _repository;
  GetChatHistory(this._repository);
  Future<List<ChatMessage>> call(String conversationId) {
    return _repository.getMessages(conversationId);
  }
}
