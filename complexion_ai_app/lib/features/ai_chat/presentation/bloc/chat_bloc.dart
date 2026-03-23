import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<ChatMessageSent>(_onMessageSent);
  }

  Future<void> _onMessageSent(ChatMessageSent event, Emitter<ChatState> emit) async {
    // Add user message optimistically
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: 'temp',
      role: 'user',
      content: event.content,
      imagePath: event.imagePath,
      createdAt: DateTime.now(),
    );
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isSending: true,
    ));

    // TODO: Wire up repository for real AI response
    await Future.delayed(const Duration(seconds: 1));

    final aiMessage = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      conversationId: 'temp',
      role: 'assistant',
      content: 'Based on your recent analysis, your skin is showing improvement in hydration. I\'d recommend continuing with your current routine and adding a gentle AHA exfoliant once a week to help with texture.',
      createdAt: DateTime.now(),
    );
    emit(state.copyWith(
      messages: [...state.messages, aiMessage],
      isSending: false,
    ));
  }
}
