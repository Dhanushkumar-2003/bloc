import 'package:bloc/bottomnav.dart';
import 'package:bloc/home.dart';
import 'package:bloc/public.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AccessibleBlogScreen extends StatefulWidget {
  @override
  _AccessibleBlogScreenState createState() => _AccessibleBlogScreenState();
}

class _AccessibleBlogScreenState extends State<AccessibleBlogScreen> {
  final FocusNode _focusNode = FocusNode();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _command = "Say 'Next' or 'Previous'";

  int _currentIndex = 0;
  final List<String> blogPosts = [
    "Blog Post 1: Welcome to our accessible blog!",
    "Blog Post 2: Flutter accessibility best practices.",
    "Blog Post 3: Implementing voice navigation in apps.",
  ];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(onResult: (result) {
          setState(() {
            _command = result.recognizedWords;
            if (_command.toLowerCase() == "next") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Public_account()));
            } else if (_command.toLowerCase() == "previous") {
              _previousBlog();
            }
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  void _nextBlog() {
    setState(() {
      if (_currentIndex < blogPosts.length - 1) {
        _currentIndex++;
      }
    });
  }

  void _previousBlog() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accessible Blog")),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  _nextBlog();
                } else if (details.primaryVelocity! > 0) {
                  _previousBlog();
                }
              },
              child: Focus(
                focusNode: _focusNode,
                autofocus: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      blogPosts[_currentIndex],
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text("Use Left/Right Arrows or Swipe to navigate"),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _listen,
                      child: Text(_isListening
                          ? "Listening..."
                          : "Start Voice Command"),
                    ),
                    SizedBox(height: 10),
                    Text("Command: $_command",
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoiceCommandScreen extends StatefulWidget {
  @override
  _VoiceCommandScreenState createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Say 'Hello' to show the button!";
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _startListening(); // Start listening immediately
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "notListening") {
          _restartListening(); // Restart if it stops
        }
      },
    );

    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            istenMode:
            stt.ListenMode.dictation;
            _text = result.recognizedWords;
            if (_text.toLowerCase().contains("hello")) {
              _showButton = true;
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             MyHomePage())); // Show button when "hello" is detected
            }
          });
        },
      );
    }
  }

  void _restartListening() {
    Future.delayed(Duration(seconds: 1), () {
      if (!_speech.isListening) {
        _startListening();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voice Command Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _text,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (_showButton) // Show button only when "hello" is detected
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showButton = false; // Hide button after clicking
                  });
                },
                child: Text("Voice Command Button"),
              ),
          ],
        ),
      ),
    );
  }
}
