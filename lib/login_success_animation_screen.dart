import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoginAnimationScreen extends StatefulWidget {
  const LoginAnimationScreen({super.key});

  @override
  _LoginAnimationScreenState createState() => _LoginAnimationScreenState();
}

class _LoginAnimationScreenState extends State<LoginAnimationScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/animations/succesfull_login.mp4')
          ..initialize().then((_) {
            // Once the video is initialized, play it and stop at the end
            _controller.play();
            _controller.setLooping(false);
            setState(() {}); // Rebuild the widget to show the video
          });

    _controller.addListener(() {
      // When the video finishes playing, navigate to the dashboard
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCAE6D3), // Maintain the background color
      body: Center(
        // Show the video player or a loading indicator if the video is not initialized
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(), // Show loading until video is ready
      ),
    );
  }
}
