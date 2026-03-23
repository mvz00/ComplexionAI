import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_message_model.dart';

class ChatRemoteDataSource {
  final SupabaseClient _supabase;
  ChatRemoteDataSource(this._supabase);

  Future<String> createConversation(String userId) async {
    final data = await _supabase
        .from('chat_conversations')
        .insert({'user_id': userId})
        .select('id')
        .single();
    return data['id'] as String;
  }

  Future<ChatMessageModel> sendMessage(String conversationId, String content, {String? imagePath}) async {
    // Save user message
    await _supabase.from('chat_messages').insert({
      'conversation_id': conversationId,
      'role': 'user',
      'content': content,
      'image_path': imagePath,
    });

    // Call AI edge function
    final response = await _supabase.functions.invoke('ai-chat', body: {
      'conversation_id': conversationId,
      'message': content,
      'image_path': imagePath,
    });

    final aiResponse = response.data as Map<String, dynamic>;

    // Save and return AI response
    final saved = await _supabase.from('chat_messages').insert({
      'conversation_id': conversationId,
      'role': 'assistant',
      'content': aiResponse['content'],
      'metadata': aiResponse['metadata'],
    }).select().single();

    return ChatMessageModel.fromJson(saved);
  }

  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    final data = await _supabase
        .from('chat_messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at');
    return (data as List).map((e) => ChatMessageModel.fromJson(e)).toList();
  }
}
