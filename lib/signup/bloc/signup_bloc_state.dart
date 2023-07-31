import 'package:equatable/equatable.dart';

enum Event { idle, error, loading, done }

class SignUpBlocState extends Equatable {
  @override
  List<Object?> get props =>
      [errorMessage, registerApiState, showPassword, showConfirmPassword];

  final String errorMessage;
  final Event registerApiState;
  final bool showPassword;
  final bool showConfirmPassword;

  const SignUpBlocState({
    this.errorMessage = '',
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.registerApiState = Event.idle,
  });

  SignUpBlocState copyWith(
      {String? errorMessage,
      Event? registerApiState,
      bool? showPassword,
      bool? showConfirmPassword}) {
    return SignUpBlocState(
      errorMessage: errorMessage ?? this.errorMessage,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      registerApiState: registerApiState ?? this.registerApiState,
    );
  }
}
