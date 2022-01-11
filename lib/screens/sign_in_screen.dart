import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tiktok_flutter/screens/auth_viewmodel.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final authService = GetIt.instance<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                authService.signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
              },
              child: Text("Sign in"),
            )
          ],
        ),
      ),
    );
  }
}
