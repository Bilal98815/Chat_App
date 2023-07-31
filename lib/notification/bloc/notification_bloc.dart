import 'package:bloc/bloc.dart';
import 'package:chat_app/auth_service.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/repositories/notification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'notification_bloc_state.dart';

class NotificationBloc extends Cubit<NotificationBlocState>{
  NotificationBloc({required this.authService}) : super(NotificationBlocState());

  final NotificationRepository notificationRepository = NotificationRepository();
  final AuthService authService;

  void notificationAPI(String message)async{
    final user = await authService.getUserDetails(user2Email);
    final user2 = await authService.getUserDetails(emailId);

    debugPrint("--------->>>>>> USER 2 Email: $user2Email");
    debugPrint("--------->>>>>> USER 2 TOKEN: ${user?.fcm}");
    debugPrint("--------->>>>>> USER 2 TOKEN: ${user?.name}");

    debugPrint("--------->>>>>> USER 1 TOKEN: ${user?.fcm}");

    if(user != null) {
      notificationRepository.sendNotification(
          user?.fcm ?? '', message, user2?.name ?? '');
    }else{
      debugPrint("--------->>>>>> USER not found");
    }
  }

}