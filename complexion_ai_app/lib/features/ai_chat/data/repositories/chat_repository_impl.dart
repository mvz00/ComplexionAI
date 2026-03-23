import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<ChatMessage> sendMessage(String conversationId, String content, {String? imagePath}) {
    return _remoteDataSource.sendMessage(conversationId, content, imagePath: imagePath);
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) {
    return _remoteDataSource.getMessages(conversationId);
  }

  @override
  Future<String> createConversation(String userId) {
    return _remoteDataSource.createConversation(userId);
  }
}
