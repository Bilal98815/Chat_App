import 'package:bloc/bloc.dart';
import 'package:chat_app/signup/bloc/signup_bloc_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../auth_service.dart';


class SignUpBloc extends Cubit<SignUpBlocState>{
  SignUpBloc({required this.authService}) : super(const SignUpBlocState());


  final AuthService authService;

  Future register(String email, String name, String password, String confirmPassword) async {
    emit(state.copyWith(registerApiState: Event.loading));
    try {
      await authService.registerUser(email, name, password, confirmPassword);
      emit(state.copyWith(registerApiState: Event.done));
    } on FirebaseException catch(e){
      debugPrint('----->>> ${e.toString()}');
      updateError(e.code);
    }
    catch(e){
      debugPrint('----->>> ${e.toString()}');
      updateError(e.toString());
    }
  }

  void showPassword(){
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void showConfirmPassword(){
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  void updateError(String exception){
    switch(exception){
      case 'Something went wrong':
        String error = 'Something went wrong';
        emit(state.copyWith(errorMessage: error, registerApiState: Event.error));
        break;
      case 'Enter correct credentials':
        String error = 'Enter correct credentials';
        emit(state.copyWith(errorMessage: error, registerApiState: Event.error));
        break;
      case '[firebase_auth/invalid-email] The email address is badly formatted':
        String error = 'Invalid email format';
        emit(state.copyWith(errorMessage: error, registerApiState: Event.error));
        break;
      case 'invalid-email':
        String error = 'Invalid email format';
        emit(state.copyWith(errorMessage: error, registerApiState: Event.error));
        break;
      case 'wrong-password':
        String error = 'Invalid Password';
        emit(state.copyWith(errorMessage: error, registerApiState: Event.error));
        break;
      case 'user-not-found':
        String error = 'User not found';
        emit(state.copyWith(errorMessage: error, registerApiState: Event.error));
        break;
      case 'user-disabled':
        String error = 'User account disabled';
        emit(state.copyWith(errorMessage: error, registerApiState: Event.error));
        break;
      case 'email-already-in-use':
        String error = 'Email is already in use';
        emit(state.copyWith(errorMessage: error, registerApiState: Event.error));
        break;
      case 'weak-password':
        String error = 'Weak Password';
        emit(state.copyWith(errorMessage: error, registerApiState: Event.error));
        break;
    }
  }


}