import 'package:flutter/material.dart';
import 'dart:async';
import 'package:js/js_util.dart' as js_util;
import 'dart:html' as html;

// import 'package:vwo_insights_flutter_sdk/vwo_insights_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _seconds = 0;
  Timer? _timer;
  final TextEditingController _inputController = TextEditingController();
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _updateUrl('/');
    _startTimer();
    // VwoFlutter.resumeRecording();
  }

  void _updateUrl(String path) {
    js_util.callMethod(html.window.history, 'pushState', [null, '', path]);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _startTimer();
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer),
            SizedBox(width: 10),
            Text('Timer First Page'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Display
            Text(
              'Timer: $_seconds seconds',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: LinearProgressIndicator(
                value: (_seconds % 10) / 10, // Loops progress every 10 sec
                minHeight: 8,
                borderRadius: BorderRadius.circular(5),
              ),
            ),

            // Timer Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pause' : 'Resume'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _seconds = 0;
                    });
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Existing VWO Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter text',
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Existing VWO Buttons
            ElevatedButton(
              onPressed: () {
                final Map<String, dynamic> attributes = {};
                attributes["email"] = "abc@xyz.com";
                attributes["name"] = "VWO Insights";
               // VwoFlutter.sendCustomAttribute(attributes);
              },
              child: const Text('Custom attribute'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final Map<String, dynamic> addToCartEvent = {};
                addToCartEvent["productName"] = "VWO Insights";
                addToCartEvent["productQuantity"] = 1;
               // VwoFlutter.sendCustomEvent("addToCart", addToCartEvent);
              },
              child: const Text('Custom Event'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
               // VwoFlutter.resumeRecording();
              },
              child: const Text('Resume Rec'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
             // VwoFlutter.pauseRecording();
              },
              child: const Text('Pause Rec'),
            ),

            const SizedBox(height: 20),

            // Navigate to Second Page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              child: const Text('Visit Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String userInput = '';

  @override
  void initState() {
    super.initState();
    _updateUrl('/second');
  }

  void _updateUrl(String path) {
    js_util.callMethod(html.window.history, 'pushState', [null, '', path]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
        automaticallyImplyLeading: false, // Hides the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Second Page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'This page demonstrates a more interactive UI with useful widgets.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            // Image Placeholder
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/150'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Text Field for User Input
            TextField(
              onChanged: (value) {
                setState(() {
                  userInput = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter something...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),

            const SizedBox(height: 20),

            // Show Input Text
            Text(
              userInput.isEmpty ? 'Your input will appear here' : 'You entered: $userInput',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // // Loading Animation
            // const CircularProgressIndicator(),

            const SizedBox(height: 20),

            // Features List
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("🔥 Interactive UI"),
                Text("🎨 Improved design"),
                Text("📲 User input support"),
                Text("🔄 Animated elements"),
              ],
            ),

            const SizedBox(height: 30),

            // Styled Button to Go Back
            ElevatedButton.icon(
              onPressed: () {
                _updateUrl('/');
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              label: const Text('Back to First Page'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
