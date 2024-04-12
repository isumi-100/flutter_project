import 'dart:math'; //for use Random
import 'package:flutter/material.dart'; // Importing Flutter material package

void main() {
  runApp(const MyApp()); // Running the application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor for MyApp widget

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Building the app UI
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Write Anything'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title}); // Constructor for MyHomePage
  final String title; // title for the home page

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState(); // Creating state for the home page
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController
      _textController; // Declaring text controller variable
  String _displayedMessage = ''; // Variable to display message
  final List<String> _imagePaths = [
    // List of image paths
    './images/test1.png', // Add image paths to display here
    './images/test2.png',
    './images/test3.png',
  ];
  final Random _random = Random(); // Random number generator
  String _currentImagePath =
      './images/test2.png'; // Variable to hold current image path

  @override
  void initState() {
    // Initializing state
    super.initState();
    _textController = TextEditingController(); // Initializing text controller
  }

  @override
  void dispose() {
    // Disposing state
    _textController.dispose(); // Disposing text controller
    super.dispose();
  }

  void _sendMessage() {
    // Method to handle sending message
    String message =
        _textController.text; // Getting message from text controller
    setState(() {
      _displayedMessage =
          message.split('').join('　'); // Updating displayed message
    });
    _textController.clear(); // Clearing text field
    int index =
        _random.nextInt(_imagePaths.length); // Generating random index(image)
    setState(() {
      _currentImagePath = _imagePaths[index]; // Updating current image path
    });
  }

  @override
  Widget build(BuildContext context) {
    // Building UI
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text(
            //   'You can write anything !',
            // ), //This text widget is used for my practice, but not needed finally.
            const SizedBox(height: 20),
            if (_displayedMessage.isNotEmpty) // Conditionally displaying text
              Text(
                _displayedMessage, // Displaying entered message
                style: const TextStyle(fontSize: 25),
              ),
            Image.asset(
              _currentImagePath, // Displaying current image
              width: 200,
              height: 200,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.8, // Setting text field width
              child: TextField(
                controller: _textController, // Setting text field controller
                decoration: InputDecoration(
                  labelText: "nanndemo-douzo", // Setting text field label
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage, // Setting send message method
        child: const Icon(Icons.send), // Setting send icon
      ),
    );
  }
}
