import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Upload App',
      home: VideoUploadScreen(),
    );
  }
}

class VideoUploadScreen extends StatefulWidget {
  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  late VideoPlayerController _controller;
  late File _pickedFile;
  final picker = ImagePicker();
  late String videoUrl;

  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedFile = File(pickedFile.path);
      _controller = VideoPlayerController.file(_pickedFile);
      await _controller.initialize();
      setState(() {});
    }
  }

  Future<void> uploadVideo() async {
    if (_pickedFile != null) {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('videos/${DateTime.now()}.mp4');
      final UploadTask uploadTask = storageReference.putFile(_pickedFile);
      final TaskSnapshot downloadUrl = await uploadTask;
      videoUrl = await downloadUrl.ref.getDownloadURL();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _controller != null
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            ElevatedButton(
              onPressed: pickVideo,
              child: Text('Pick Video'),
            ),
            ElevatedButton(
              onPressed: uploadVideo,
              child: Text('Upload Video'),
            ),
            // videoUrl != null ? VideoPlayerWidget(videoUrl) : Container(),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;

  VideoPlayerWidget(this.videoUrl);

  @override
  Widget build(BuildContext context) {
    return VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      // Play with better performance on mobile devices.
      // useMobileVideoPlayer: true,
    ).value.isInitialized
        ? AspectRatio(
            aspectRatio: 16 / 9,
            child: VideoPlayer(
              VideoPlayerController.networkUrl(Uri.parse(videoUrl)
                  // useMobileVideoPlayer: true,
                  ),
            ),
          )
        : const CircularProgressIndicator();
  }
}
