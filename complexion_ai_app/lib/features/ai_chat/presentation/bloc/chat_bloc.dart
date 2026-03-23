import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/get_chat_history.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage _sendMessage;
  final GetChatHistory _getChatHistory;
  final ChatRepository _chatRepository;

  ChatBloc({
    required SendMessage sendMessage,
    required GetChatHistory getChatHistory,
    required ChatRepository chatRepository,
  })  : _sendMessage = sendMessage,
        _getChatHistory = getChatHistory,
        _chatRepository = chatRepository,
        super(const ChatState()) {
    on<ChatMessageSent>(_onMessageSent);
    on<ChatHistoryRequested>(_onHistoryRequested);
  }

  Future<void> _onHistoryRequested(ChatHistoryRequested event, Emitter<ChatState> emit) async {
    emit(state.copyWith(isLoadingHistory: true, error: null));
    try {
      final messages = await _getChatHistory(event.conversationId);
      emit(state.copyWith(
        isLoadingHistory: false,
        conversationId: event.conversationId,
        messages: messages,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingHistory: false, error: e.toString()));
    }
  }

  Future<void> _onMessageSent(ChatMessageSent event, Emitter<ChatState> emit) async {
    // Add user message optimistically
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: state.conversationId ?? '',
      role: 'user',
      content: event.content,
      imagePath: event.imagePath,
      createdAt: DateTime.now(),
    );
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isSending: true,
      error: null,
    ));

    try {
      String conversationId = state.conversationId ?? '';

      // Create conversation if none exists yet
      if (conversationId.isEmpty) {
        final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
        conversationId = await _chatRepository.createConversation(userId);
        emit(state.copyWith(conversationId: conversationId));
      }

      final aiMessage = await _sendMessage(conversationId, event.content, imagePath: event.imagePath);

      emit(state.copyWith(
        messages: [...state.messages, aiMessage],
        isSending: false,
      ));
    } catch (e) {
      emit(state.copyWith(isSending: false, error: e.toString()));
    }
  }
}
