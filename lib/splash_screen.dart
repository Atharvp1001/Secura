// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:secura_app/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoLoaded = false; // Track video load state

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/animations/loading_animation.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoLoaded = true;
          _controller.play();
          _controller.setLooping(false);
        });
      }).catchError((e) {
        print('Error loading video: $e');
        _navigateToNextScreen(); // Navigate directly if video fails to load
      });

    // Listen to the video's end event
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _navigateToNextScreen();
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (mounted) {
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const DashboardScreen(),
  ),
);

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
      backgroundColor: const Color(0xFFCAE6D3),
      body: Center(
        child: _isVideoLoaded
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(), // Show a loading indicator if video isn't loaded yet
      ),
    );
  }
}
