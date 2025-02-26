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

class _FadingTextAnimationState extends State<FadingTextAnimation>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  Color _textColor = Colors.blue; // Default text color
  bool _showFrame = false; // Frame toggle
  bool _imageVisible = true; // Image fade animation toggle
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Rotates continuously
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void toggleImageVisibility() {
    setState(() {
      _imageVisible = !_imageVisible;
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
        title: const Text('Fading Text Animation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.wb_sunny), // Toggle theme icon
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.palette), // Open color picker
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Pick a text color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _textColor,
                          onColorChanged: changeColor,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
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
        onTap: toggleVisibility, // Tap anywhere to toggle visibility
        onHorizontalDragEnd: (details) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondFadingScreen()),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Text(
                  'Hello, Flutter!',
                  style: TextStyle(fontSize: 24, color: _textColor),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: toggleImageVisibility, // Tap to fade image
                child: AnimatedOpacity(
                  opacity: _imageVisible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  child: Container(
                    decoration:
                        _showFrame
                            ? BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 4),
                              borderRadius: BorderRadius.circular(10),
                            )
                            : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Rounded corners
                      child: Image.asset(
                        'assets/image.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('Show Frame'),
                value: _showFrame,
                onChanged: (bool value) {
                  setState(() {
                    _showFrame = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              RotationTransition(
                turns: _rotationController,
                child: const Icon(Icons.refresh, size: 50, color: Colors.green),
              ),
              const Text("Rotating Icon"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: const Icon(Icons.play_arrow),
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
      appBar: AppBar(title: const Text("Second Animation Screen")),
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(seconds: 3), // Different duration
          curve: Curves.easeInOut,
          child: const Text(
            'Different Fade Duration!',
            style: TextStyle(fontSize: 24, color: Colors.purple),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
