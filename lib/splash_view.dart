import 'dart:async';

import 'package:chat_app/auth_service.dart';
import 'package:chat_app/login/login_view.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/shared_preferences/shared_preferences.dart';
import 'package:chat_app/users/users_view.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final Preferences prefs = Preferences();
  final AuthService service = AuthService();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      final user = await prefs.getSharedPreferenceUser();
      debugPrint('Shared Preferences: -------->>>>>${user.name}');
      debugPrint('Shared Preferences: -------->>>>>${user.email}');
      debugPrint('Shared Preferences: -------->>>>>${user.status}');
      if (user.email != null && user.email!.isNotEmpty) {
        emailId = user.email ?? '';
        await service.updateStatus('online', user.email!);
        final finalUser = await service.getUserDetails(user.email!);
        debugPrint('Shared Preferences Status after updating status: -------->>>>>${finalUser?.status}');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UsersView(email: user.email ?? '')));
      }
      else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => LoginView()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    font = MediaQuery.of(context).size.width / 400;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
          child: Image.asset(
        'assets/chat.png',
        width: 150,
        height: 150,
      )),
    );
  }
}
