import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';

enum APIState { idle, error, loading, done }

class UsersBlocState extends Equatable {
  @override
  List<Object?> get props => [userApiState, errorMessage, users];

  final List<UserModel> users;
  final String errorMessage;
  final APIState userApiState;

  const UsersBlocState({
    this.errorMessage = '',
    this.userApiState = APIState.idle,
    this.users = const [],
  });

  UsersBlocState copyWith({
    String? errorMessage,
    APIState? userApiState,
    List<UserModel>? users,
  }) {
    return UsersBlocState(
      errorMessage: errorMessage ?? this.errorMessage,
      userApiState: userApiState ?? this.userApiState,
      users: users ?? this.users,
    );
  }
}
