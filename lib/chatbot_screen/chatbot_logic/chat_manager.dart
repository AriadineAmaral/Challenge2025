import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatManager {
  final List<Map<String, String>> _chatHistory = [];
  final List<Map<String, String>> _messages = [];
  final List<List<Map<String, String>>> _allChats = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = "";
  bool _showInitialScreen = true;

  ChatManager() {
    _loadChats();
  }

  Future<void> _loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatsJson = prefs.getStringList('all_chats') ?? [];
    _allChats.clear();
    for (final chatJson in chatsJson) {
      final chat = (jsonDecode(chatJson) as List)
          .map<Map<String, String>>(
            (msg) => {
              'role': msg['role'] as String,
              'content': msg['content'] as String,
            },
          )
          .toList();
      _allChats.add(chat);
    }
  }

  Future<void> _saveChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatsJson = _allChats.map((chat) => jsonEncode(chat)).toList();
    await prefs.setStringList('all_chats', chatsJson);
  }

  Future<void> sendMessage(String message, {Function(String)? onResponse}) async {
    if (message.trim().isEmpty) return;

    if (_showInitialScreen) {
      _showInitialScreen = false;
    }
    _messages.add({'role': 'user', 'content': message});
    _chatHistory.add({'role': 'user', 'content': message});
    _controller.clear();
    _scrollToBottom();

    String response = await _callAIAPI();
    _messages.add({'role': 'assistant', 'content': response});
    _chatHistory.add({'role': 'assistant', 'content': response});
    _scrollToBottom();
    if (onResponse != null) onResponse(response);
  }

  Future<String> _callAIAPI() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      return 'Erro: Chave API não encontrada no .env';
    }
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );

    final headers = {'Content-Type': 'application/json'};

    final contents = _chatHistory.map((msg) {
      return {
        "role": msg['role'] == "user" ? "user" : "model",
        "parts": [
          {"text": msg['content']},
        ],
      };
    }).toList();

    final body = jsonEncode({"contents": contents});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Erro da API: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Erro de conexão: $e';
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void newChat() {
    if (_messages.isNotEmpty) {
      _allChats.add(List.from(_messages));
      _saveChats();
    }
    _messages.clear();
    _chatHistory.clear();
    _showInitialScreen = true;
  }

  void clearHistory() {
    _allChats.clear();
    _saveChats();
  }

  List<Map<String, String>> get messages => _messages;
  List<List<Map<String, String>>> get allChats => _allChats;
  String get searchQuery => _searchQuery;
  set searchQuery(String value) => _searchQuery = value;
  bool get showInitialScreen => _showInitialScreen;
  set showInitialScreen(bool value) => _showInitialScreen = value; // Novo setter
  TextEditingController get controller => _controller;
  ScrollController get scrollController => _scrollController;
  List<Map<String, String>> get chatHistory => _chatHistory;

  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
  }
}