import 'package:equatable/equatable.dart';

class ChatBlocState extends Equatable {
  @override
  List<Object?> get props => [user2Name, user2Email, chatId, user2Status];

  final String user2Name;
  final String user2Email;
  final String chatId;
  final String user2Status;

  const ChatBlocState(
      {this.user2Name = '', this.user2Email = '', this.chatId = '', this.user2Status = ''});

  ChatBlocState copyWith({String? name, String? email, String? chatId, String? user2Status}) {
    return ChatBlocState(
        user2Name: name ?? user2Name,
        user2Email: email ?? this.user2Email,
        user2Status: user2Status ?? this.user2Status,
        chatId: chatId ?? this.chatId);
  }
}
