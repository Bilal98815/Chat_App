import 'package:bloc/bloc.dart';
import 'package:chat_app/users/bloc/users_bloc_state.dart';

import '../../auth_service.dart';

class UsersBloc extends Cubit<UsersBlocState> {
  UsersBloc({
    required this.authService,
  }) : super(const UsersBlocState());

  final AuthService authService;

  Future fetchUsers(String email) async {
    emit(state.copyWith(userApiState: APIState.loading));
    try {
      final allUsers = await authService.getAllUsers(email);
      emit(state.copyWith(users: allUsers, userApiState: APIState.done));
    } catch (e) {
      emit(
        state.copyWith(
          users: [],
          userApiState: APIState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
