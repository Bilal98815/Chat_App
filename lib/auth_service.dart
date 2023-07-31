import 'package:chat_app/login/bloc/login_bloc_state.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/signup/bloc/signup_bloc.dart';
import 'package:chat_app/signup/bloc/signup_bloc_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login/bloc/login_bloc.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  bool isPasswordConfirmed(String password, String confirmPassword) {
    if (password == confirmPassword) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signInUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> registerUser(String email, String name, String password,
      String confirmPassword) async {
    if (isPasswordConfirmed(password, confirmPassword)) {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel user = UserModel(
          email: email,
        name: name,
        status: 'offline'
      );
      await addUserDetails(user);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future addUserDetails(UserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.email).set({
      'name': user.name,
      'email': user.email,
      'status': user.status,
    });
  }

  Future updateUser(String token, String email, String status) async {
    debugPrint('------------->>>>>>>> TOKEN: $token');
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'fcm': token,
      'status': status,
    });
  }

  Future updateStatus(String status, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'status': status,
    });
  }


  Future<UserModel?> getUserDetails(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();
        debugPrint('Retrieved user data: $userData');

        return UserModel.fromJson(userData);
      } else {
        debugPrint('User not found');
        return null;
      }
    } catch (e) {
      debugPrint('Error retrieving user details: $e');
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers(String email) async {
    List<UserModel> users = [];
    final snapShot = await FirebaseFirestore.instance.collection('users').get();

    for (final doc in snapShot.docs) {
      if (doc.id != email) {
        debugPrint("-----------> ${doc.id} <------------");
        final user = UserModel(
          name: doc.get('name'),
          email: doc.get('email'),
        );
        users.add(user);
      }
    }
    return users;
  }

  Future<String?> getFCMToken()async{
    NotificationSettings settings = await _messaging.requestPermission();
    String? token = await _messaging.getToken();
    return token;
  }

}
