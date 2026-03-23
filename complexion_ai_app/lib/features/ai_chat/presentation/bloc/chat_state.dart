import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isSending;
  final bool isLoadingHistory;
  final String? conversationId;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isSending = false,
    this.isLoadingHistory = false,
    this.conversationId,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    bool? isLoadingHistory,
    String? conversationId,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      conversationId: conversationId ?? this.conversationId,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, isSending, isLoadingHistory, conversationId, error];
}
