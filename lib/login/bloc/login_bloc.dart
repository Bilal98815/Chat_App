
import 'package:bloc/bloc.dart';
import 'package:chat_app/auth_service.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'login_bloc_state.dart';

class LoginBloc extends Cubit<LoginBlocState> {
  LoginBloc({
    required this.authService,
  }) : super(const LoginBlocState());

  final AuthService authService;

  Future logout() async {
    await authService.signOut();
  }

  Future login(String email, String password) async {
    emit(state.copyWith(authApiState: APIState.loading));
    String? token = await authService.getFCMToken();
    try {
      await authService.signInUser(email, password);
      await authService.updateUser(token!, email, 'online');
      emit(state.copyWith(authApiState: APIState.done));
      emailId = email;
    } on FirebaseException catch(e) {
      debugPrint('----->>> ${e.toString()}');
      updateError(e.code);
    } catch(e){
      updateError(e.toString());
    }
  }

  void updateError(String exception) {
    switch (exception) {
      case 'Something went wrong':
        String error = 'Something went wrong';
        emit(state.copyWith(
          errorMessage: error,
          authApiState: APIState.error,
        ));
        break;
      case '[firebase_auth/unknown] Given String is empty or null':
        String error = 'Enter correct credentials';
        emit(state.copyWith(
          errorMessage: error,
          authApiState: APIState.error,
        ));
        break;
      case 'Enter correct credentials':
        String error = 'Enter correct credentials';
        emit(state.copyWith(
          errorMessage: error,
          authApiState: APIState.error,
        ));
        break;
      case 'invalid-email':
        String error = 'Invalid email format';
        emit(state.copyWith(
          errorMessage: error,
          authApiState: APIState.error,
        ));
        break;
      case 'wrong-password':
        String error = 'Invalid Password';
        emit(state.copyWith(
          errorMessage: error,
          authApiState: APIState.error,
        ));
        break;
      case 'user-not-found':
        String error = 'User not found';
        emit(state.copyWith(
          errorMessage: error,
          authApiState: APIState.error,
        ));
        break;
      case 'user-disabled':
        String error = 'User account disabled';
        emit(state.copyWith(
          errorMessage: error,
          authApiState: APIState.error,
        ));
        break;
      case 'email-already-in-use':
        String error = 'Email is already in use';
        emit(state.copyWith(
          errorMessage: error,
          authApiState: APIState.error,
        ));
        break;
      case 'weak-password':
        String error = 'Weak Password';
        emit(state.copyWith(
          errorMessage: error,
          authApiState: APIState.error,
        ));
        break;
    }
  }

  void keepLoggedIn(){
    emit(state.copyWith(keepLoggedIn: !state.keepLoggedIn));
  }

  void showPassword(){
    emit(state.copyWith(showPassword: !state.showPassword));
  }
}
