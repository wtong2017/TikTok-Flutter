import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tiktok_flutter/screens/auth_viewmodel.dart';
import 'package:tiktok_flutter/screens/create_screen.dart';
import 'package:tiktok_flutter/screens/feed_screen.dart';
import 'package:tiktok_flutter/screens/sign_in_screen.dart';
import 'package:tiktok_flutter/service_locator.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  cameras = await availableCameras();
  setup();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LandingScreen(),
  ));
}

class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);
  final authViewModel = GetIt.instance<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authViewModel.authStateChanges,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen();
        }
        return Container(
          decoration: BoxDecoration(color: Colors.white),
          child: FeedScreen(),
        );
      },
    );
  }
}
