import 'package:equatable/equatable.dart';

enum APIState { idle, error, loading, done }

class LoginBlocState extends Equatable {
  @override
  List<Object?> get props => [authApiState, errorMessage, showPassword, keepLoggedIn];

  final String errorMessage;
  final APIState authApiState;
  final bool showPassword;
  final bool keepLoggedIn;

  const LoginBlocState({
    this.errorMessage = '',
    this.showPassword = false,
    this.keepLoggedIn = false,
    this.authApiState = APIState.idle,
  });

  LoginBlocState copyWith({
    String? errorMessage,
    APIState? authApiState,
    bool? showPassword,
    bool? keepLoggedIn
  }) {
    return LoginBlocState(
      errorMessage: errorMessage ?? this.errorMessage,
      authApiState: authApiState ?? this.authApiState,
      keepLoggedIn: keepLoggedIn ?? this.keepLoggedIn,
      showPassword: showPassword ?? this.showPassword
    );
  }
}
