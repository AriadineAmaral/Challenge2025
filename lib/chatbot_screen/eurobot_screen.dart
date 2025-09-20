import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chatbot_logic/chat_manager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late final ChatManager _chatManager = ChatManager();

  @override
  void dispose() {
    _chatManager.dispose();
    super.dispose();
  }

  Widget _buildMessageBubble(String role, String text) {
    final isUser = role == 'user';

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF0033A0) : Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                bottomRight: isUser ? Radius.zero : const Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: MarkdownBody(
              data: text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 15,
                  color: isUser ? Colors.white : Colors.black87,
                ),
                a: const TextStyle(color: Color(0xFFFFD100)),
              ),
              onTapLink: (text, href, title) async {
                if (href != null) {
                  final uri = Uri.parse(href);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    final filteredChats = _chatManager.allChats.where((chat) {
      final content = chat.map((msg) => msg['content']).join(" ").toLowerCase();
      return content.contains(_chatManager.searchQuery.toLowerCase());
    }).toList();

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 165, 165, 165),
          width: 2,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Color(0xFFFFD100)),
                  SizedBox(width: 6),
                  Text("Novo Chat", style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              onTap: _chatManager.newChat,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0033A0)),
                  hintText: "Procurar Chats...",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 165, 165, 165),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 165, 165, 165),
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _chatManager.searchQuery = value;
                  });
                },
              ),
            ),
            const Divider(color: Color.fromARGB(255, 165, 165, 165)),
            Expanded(
              child: ListView.builder(
                itemCount: filteredChats.length,
                itemBuilder: (context, index) {
                  final chat = filteredChats[index];
                  String preview = "Novo Chat";
                  for (final msg in chat) {
                    if (msg['role'] == 'user') {
                      preview = msg['content']!.substring(
                        0,
                        msg['content']!.length > 30 ? 30 : msg['content']!.length,
                      );
                      break;
                    }
                  }
                  return ListTile(
                    leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFF0033A0)),
                    title: Text(preview, style: const TextStyle(fontWeight: FontWeight.w500)),
                    onTap: () {
                      setState(() {
                        _chatManager.messages.clear();
                        _chatManager.messages.addAll(chat);
                        _chatManager.chatHistory.clear();
                        _chatManager.chatHistory.addAll(chat);
                        _chatManager.showInitialScreen = false;
                      });
                    },
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text("Limpar Histórico", style: TextStyle(color: Colors.red)),
              onTap: _chatManager.clearHistory,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            if (_chatManager.showInitialScreen)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            const Color(0xFF0033A0),
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'images/logoEuroFarma.png',
                            width: 200,
                            height: 200,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'EuroBot',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0033A0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (!_chatManager.showInitialScreen)
              Expanded(
                child: ListView.builder(
                  controller: _chatManager.scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _chatManager.messages.length,
                  itemBuilder: (context, index) {
                    final msg = _chatManager.messages[index];
                    return _buildMessageBubble(msg['role']!, msg['content']!);
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatManager.controller,
                      decoration: InputDecoration(
                        hintText: "Digite sua mensagem...",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF0033A0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF0033A0), width: 2),
                        ),
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onSubmitted: (message) async {
                        await _chatManager.sendMessage(
                          message,
                          onResponse: (_) => setState(() {}),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF0033A0)),
                    onPressed: () async {
                      await _chatManager.sendMessage(
                        _chatManager.controller.text,
                        onResponse: (_) => setState(() {}),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 600;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                _buildSidebar(),
                Expanded(child: _buildChatArea()),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('EuroBot'),
              backgroundColor: const Color(0xFF0033A0),
              foregroundColor: Colors.white,
            ),
            drawer: Drawer(child: _buildSidebar()),
            body: _buildChatArea(),
          );
        }
      },
    );
  }
}
