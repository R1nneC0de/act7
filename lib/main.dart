import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // Day/Night mode toggle

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: FadingTextAnimation(
        toggleTheme: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final VoidCallback toggleTheme;

  const FadingTextAnimation({required this.toggleTheme});

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.blue; // Default text color

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void changeColor(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text Animation'),
        actions: [
          IconButton(
            icon: Icon(Icons.wb_sunny), // Toggle theme icon
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.palette), // Open color picker
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Pick a text color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _textColor,
                          onColorChanged: changeColor,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondFadingScreen()),
          );
        },
        child: Center(
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Text(
              'Hello, Flutter!',
              style: TextStyle(fontSize: 24, color: _textColor),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

// Second Screen with Different Fading Duration
class SecondFadingScreen extends StatefulWidget {
  @override
  _SecondFadingScreenState createState() => _SecondFadingScreenState();
}

class _SecondFadingScreenState extends State<SecondFadingScreen> {
  bool _isVisible = true;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Animation Screen")),
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: Duration(seconds: 3), // Different duration
          curve: Curves.easeInOut, // Smoother animation
          child: Text(
            'Different Fade Duration!',
            style: TextStyle(fontSize: 24, color: Colors.purple),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
