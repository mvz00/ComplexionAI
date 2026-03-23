import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository _repository;
  SendMessage(this._repository);
  Future<ChatMessage> call(String conversationId, String content, {String? imagePath}) {
    return _repository.sendMessage(conversationId, content, imagePath: imagePath);
  }
}
