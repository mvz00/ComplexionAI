import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});
  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(ChatMessageSent(content: text));
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('AI Chat')),
            body: Column(
              children: [
                // Quick action chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _QuickChip('Why is my skin breaking out?', onTap: () {
                        _controller.text = 'Why is my skin breaking out?';
                        _send(context);
                      }),
                      _QuickChip('Can I use retinol with vitamin C?', onTap: () {
                        _controller.text = 'Can I use retinol with vitamin C?';
                        _send(context);
                      }),
                      _QuickChip('What SPF should I use?', onTap: () {
                        _controller.text = 'What SPF should I use?';
                        _send(context);
                      }),
                      _QuickChip('Suggest a cheaper alternative', onTap: () {
                        _controller.text = 'Suggest a cheaper alternative';
                        _send(context);
                      }),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Messages
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state.isLoadingHistory) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.messages.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome, size: 48, color: AppColors.skinPrimary.withAlpha(128)),
                                const SizedBox(height: 16),
                                Text(
                                  'Ask me anything about your skin',
                                  style: Theme.of(context).textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'I have context on your profile, latest analysis, and current routine.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.messages.length + (state.isSending ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.messages.length && state.isSending) {
                            // Typing indicator
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardTheme.color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const SizedBox(
                                  width: 40,
                                  child: LinearProgressIndicator(minHeight: 2),
                                ),
                              ),
                            );
                          }
                          final msg = state.messages[index];
                          return _ChatBubble(
                            content: msg.content,
                            isUser: msg.isUser,
                          );
                        },
                      );
                    },
                  ),
                ),
                // Error bar
                BlocBuilder<ChatBloc, ChatState>(
                  buildWhen: (prev, curr) => prev.error != curr.error,
                  builder: (context, state) {
                    if (state.error != null) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: AppColors.danger.withAlpha(30),
                        child: Text(
                          'Error: ${state.error}',
                          style: TextStyle(color: AppColors.danger, fontSize: 12),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // Input bar
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo_camera_outlined, size: 22),
                          onPressed: () {},
                          color: AppColors.skinTextSecondary,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'Ask about your skin...',
                              border: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onSubmitted: (_) => _send(context),
                          ),
                        ),
                        BlocBuilder<ChatBloc, ChatState>(
                          builder: (context, state) {
                            return IconButton(
                              icon: Icon(
                                Icons.send_rounded,
                                color: state.isSending ? AppColors.skinTextTertiary : AppColors.skinPrimary,
                              ),
                              onPressed: state.isSending ? null : () => _send(context),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String content;
  final bool isUser;
  const _ChatBubble({required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? AppColors.skinPrimaryBg : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isUser ? AppColors.skinPrimary : null,
                height: 1.6,
              ),
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickChip(this.label, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        onPressed: onTap,
      ),
    );
  }
}
