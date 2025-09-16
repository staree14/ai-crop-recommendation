import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:farmer_app/services/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  bool _isListening = false;
  bool _isSending = false;

  final List<String> _suggestedQuestions = [
    "What is the best fertilizer for wheat?",
    "How to prevent rice blast disease?",
    "When is the best time to plant maize?",
    "Which crop gives maximum profit?",
    "How to improve soil fertility?",
    "What is the optimal irrigation schedule?"
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    _animationController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 800)
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() => _isSending = true);

    try {
      final answer = await ApiService.askQuestion(text);
      setState(() {
        _messages.insert(0, {"question": text, "answer": answer});
        _controller.clear();
      });
      _tts.speak(answer);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching answer').tr())
      );
    }

    setState(() => _isSending = false);
  }

  Future<void> _listen() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          if (val.finalResult) {
            setState(() {
              _controller.text = val.recognizedWords;
              _isListening = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Speech recognized').tr())
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat & Voice').tr(),
        backgroundColor: Colors.green[700],
      ),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            // Suggested Questions Section (stacked vertically with light green)
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _suggestedQuestions.map((question) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[100], // light green background
                        foregroundColor: Colors.green[900], // text color
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      onPressed: () => _sendMessage(question),
                      child: Text(question, textAlign: TextAlign.left),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Chat Messages Section
            Expanded(
              child: _messages.isEmpty
                  ? Center(child: Text('Start conversation').tr())
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(msg['question']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[900])),
                                  const SizedBox(height: 4),
                                  Text(msg['answer']!),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const Divider(),

            // Input Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    color: Colors.green[700],
                    tooltip: _isListening ? 'Listening'.tr() : 'Type question'.tr(),
                    onPressed: _listen,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type question'.tr(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isSending
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.green[700],
                            ))
                        : Icon(Icons.send, color: Colors.green[700]),
                    onPressed: _isSending ? null : () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
