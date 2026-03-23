import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class ChatMessageSent extends ChatEvent {
  final String content;
  final String? imagePath;
  const ChatMessageSent({required this.content, this.imagePath});
  @override
  List<Object?> get props => [content, imagePath];
}

class ChatHistoryRequested extends ChatEvent {
  final String conversationId;
  const ChatHistoryRequested(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}
