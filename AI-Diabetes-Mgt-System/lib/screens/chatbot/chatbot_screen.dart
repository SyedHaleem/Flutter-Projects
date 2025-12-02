import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Local message list for UI
  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // ---------------------------------------------------------------------------
  // GUIDED FLOW VARIABLES
  // ---------------------------------------------------------------------------
  bool _collectingPlan = false;
  int _planStep = 0;
  final _answers = <String, String>{};

  final List<Map<String, dynamic>> _planQuestions = [
    {'key': 'diet', 'text': 'Do you have any dietary preference?', 'options': ['Balanced', 'Low-carb', 'High-protein', 'Vegetarian']},
    {'key': 'cuisine', 'text': 'Preferred cuisine?', 'options': ['Indian', 'Pakistani', 'Mediterranean', 'American']},
    {'key': 'goal', 'text': 'Primary goal?', 'options': ['Glucose stability', 'Weight control', 'Energy boost']},
  ];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    setState(() {
      _messages = [
        ChatMessage(
          text: "Hello! I'm your AI diabetes assistant.\n\n"
              "I can help with meal plans, glucose readings, or exercise tips.",
          isUser: false,
          timestamp: DateTime.now(),
        ),
        ChatMessage.quickOptions(['Create Meal Plan', 'Breakfast Ideas', 'Glucose Help']),
      ];
    });
  }

  // ---------------------------------------------------------------------------
  // CORE CHAT LOGIC
  // ---------------------------------------------------------------------------

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // 1. Update UI immediately
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    // 2. Handle Guided Flows
    if (_collectingPlan) { _handlePlanAnswer(text); return; }
    if (text.toLowerCase().contains('meal plan')) { _startMealPlanFlow(); return; }

    // 3. Send to AI
    _sendToGemini();
  }

  void _sendToGemini([String? overridePrompt]) {
    final gemini = Gemini.instance;

    // 1. Prepare the chat history
    // FIXED: Using the correct 'Part.text' syntax for version 3.0.0+
    List<Content> history = _messages
        .where((m) => !m.isQuickOptions && m.text.isNotEmpty)
        .map((m) => Content(
      role: m.isUser ? 'user' : 'model',
      parts: [
        Part.text(m.text) // <--- THIS WAS THE ERROR. CHANGED 'Parts' TO 'Part.text'
      ],
    ))
        .toList();

    // 2. Send to Gemini
    gemini.chat(
      history,
      modelName: 'gemini-1.5-flash', // Explicitly use the fast model
    ).then((value) {

      String? result = value?.output;
      if (result != null && result.isNotEmpty) {
        setState(() {
          _messages.add(ChatMessage(
            text: result,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isTyping = false;
        });
        _scrollToBottom();
      }

    }).catchError((e) {
      print("GEMINI ERROR: $e");
      setState(() {
        _messages.add(ChatMessage(
          text: "Oops! Something went wrong.\n\nError: $e",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isTyping = false;
      });
    });
  }

  // ---------------------------------------------------------------------------
  // GUIDED FLOW HELPERS
  // ---------------------------------------------------------------------------

  void _startMealPlanFlow() {
    setState(() {
      _collectingPlan = true;
      _planStep = 0;
      _answers.clear();
      _messages.add(ChatMessage(text: "Let's plan! ${_planQuestions[0]['text']}", isUser: false, timestamp: DateTime.now()));
      _messages.add(ChatMessage.quickOptions(List<String>.from(_planQuestions[0]['options'])));
    });
    _scrollToBottom();
  }

  void _handlePlanAnswer(String answer) {
    _answers[_planQuestions[_planStep]['key']] = answer;
    _planStep++;

    if (_planStep < _planQuestions.length) {
      setState(() {
        _messages.add(ChatMessage(text: _planQuestions[_planStep]['text'], isUser: false, timestamp: DateTime.now()));
        _messages.add(ChatMessage.quickOptions(List<String>.from(_planQuestions[_planStep]['options'])));
      });
    } else {
      setState(() {
        _collectingPlan = false;
        _isTyping = true;
      });

      String prompt = "Act as a diabetes expert. Create a detailed meal plan based on these preferences: $_answers. Keep it safe and healthy.";

      // Add invisible user prompt to history
      setState(() {
        _messages.add(ChatMessage(text: prompt, isUser: true, timestamp: DateTime.now()));
      });

      _sendToGemini();
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // UI BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Assistant"), backgroundColor: Colors.blue),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) return _buildTypingIndicator();
                final msg = _messages[index];
                if (msg.isQuickOptions) return _buildQuickOptions(msg.options!);
                return _buildMessageBubble(msg);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOptions(List<String> options) {
    return Wrap(
      spacing: 8,
      children: options.map((o) => ActionChip(
        label: Text(o),
        onPressed: () => _sendMessage(o),
      )).toList(),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.text.contains("Act as a diabetes expert")) {
      return const SizedBox.shrink(); // Hide the internal prompt
    }

    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isUser ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: msg.isUser
            ? Text(msg.text, style: const TextStyle(color: Colors.white))
            : MarkdownBody(data: msg.text),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Align(alignment: Alignment.centerLeft, child: Text("Thinking...", style: TextStyle(color: Colors.grey))),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isQuickOptions;
  final List<String>? options;

  ChatMessage({required this.text, required this.isUser, required this.timestamp, this.isQuickOptions = false, this.options});
  ChatMessage.quickOptions(List<String> opts) : text = '', isUser = false, timestamp = DateTime.now(), isQuickOptions = true, options = opts;
}