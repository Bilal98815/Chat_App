import 'package:bloc/bloc.dart';
import 'package:chat_app/auth_service.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'chat_bloc_state.dart';

class ChatBloc extends Cubit<ChatBlocState>{
  ChatBloc() : super(const ChatBlocState());

  final AuthService authService = AuthService();

  void updateName(String name){
    emit(state.copyWith(name: name));
  }
  
  void updateEmail(String email){
    emit(state.copyWith(email: email));
  }

  void getStatus(String email)async{
    final user = await authService.getUserDetails(email);
    debugPrint('---------->>>>> User status: ${user!.status}');
    emit(state.copyWith(user2Status: user?.status));
  }

  void setStatus(String email) async{
    await authService.updateStatus('offline', email);
    emit(state.copyWith(user2Status: 'offline'));
  }

  void listOfChatters(String chatId){
    emit(state.copyWith(chatId: chatId));
  }

  Stream<QuerySnapshot> getMessages() {
    List<String> emails = [emailId, user2Email];
    emails.sort();
    String chatId = emails.join("_");

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> retrieveStatus(){
    return FirebaseFirestore.instance.collection('users').doc(user2Email).snapshots();
  }

  void sendMessage(Map<String, dynamic> map) async {
    List<String> emails = [emailId, user2Email];
    emails.sort();
    String chatId = emails.join("_");
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(map);
  }
}