import 'package:chat_app/chat/bloc/chat_bloc.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/notification/bloc/notification_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/chat_bloc_state.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          StreamBuilder<DocumentSnapshot>(
              stream: context.read<ChatBloc>().retrieveStatus(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapShot) {
            if(snapShot.data!=null){
              Map<String, dynamic> map =
              snapShot.data!.data()
              as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Row(
                  children: [
                    Container(
                      width: width * 0.03,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: map["status"] == 'online'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      map['status'],
                      style:
                      TextStyle(color: Colors.black, fontSize: font * 18),
                    )
                  ],
                ),
              );
            }
            else{
              return Container();
            }
          })
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: BlocBuilder<ChatBloc, ChatBlocState>(builder: (context, state) {
          return Text(state.user2Name);
        }),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          children: [
            const Divider(),
            SizedBox(
              height: height * 0.01,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: context.read<ChatBloc>().getMessages(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
                  if (snapShot.data != null) {
                    return Expanded(
                      child: ListView.builder(
                          reverse: true,
                          itemCount: snapShot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map =
                                snapShot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return MessageCard(map: map);
                          }),
                    );
                  } else {
                    return Container();
                  }
                }),
            SizedBox(
              height: height * 0.02,
            ),
            const Divider(),
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.7,
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                        hintText: 'Type...',
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                  child: BlocBuilder<ChatBloc, ChatBlocState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () {
                            context
                                .read<NotificationBloc>()
                                .notificationAPI(messageController.text);
                            sendMessage(context, state.user2Email);
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.send));
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
          ],
        ),
      )),
    );
  }

  void sendMessage(BuildContext context, String email) {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> map = {
        "sender": emailId,
        "reciever": email,
        "message": messageController.text,
        "time": FieldValue.serverTimestamp(),
      };
      FocusScope.of(context).unfocus();
      messageController.clear();
      context.read<ChatBloc>().sendMessage(map);
    } else {
      print('Enter something');
    }
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.map,
  });

  final Map<String, dynamic> map;

  @override
  Widget build(BuildContext context) {
    final isMe = map['sender'] == emailId;
    final other = map['reciever'] == user2Email;

    Timestamp? timestamp = map['time'];
    String formattedTime = DateFormat("h:mm a").format(DateTime.now());
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      formattedTime = DateFormat('h:mm a').format(dateTime);
    }

    return other
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth:
                        width * 0.7, // Set a maximum width for the chat box
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.black : Colors.yellow,
                    borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(10),
                      topLeft: const Radius.circular(10),
                      bottomLeft:
                          isMe ? const Radius.circular(10) : Radius.zero,
                      bottomRight:
                          isMe ? Radius.zero : const Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(map['message'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            )),
                        SizedBox(
                          height: height * 0.007,
                        ),
                        Text(formattedTime,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth:
                        width * 0.7, // Set a maximum width for the chat box
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.black : Colors.yellow,
                    borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(10),
                      topLeft: const Radius.circular(10),
                      bottomLeft:
                          isMe ? const Radius.circular(10) : Radius.zero,
                      bottomRight:
                          isMe ? Radius.zero : const Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(map['message'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800)),
                        SizedBox(
                          height: height * 0.007,
                        ),
                        Text(formattedTime,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
