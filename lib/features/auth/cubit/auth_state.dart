import 'package:flexmerchandiser/exports.dart';
import 'package:flexmerchandiser/features/auth/models/user_model.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthOtpSent extends AuthState {
  final String message;

  AuthOtpSent({required this.message});
}

final class AuthError extends AuthState {
  final String errorMessage;

  AuthError({required this.errorMessage});
}

final class AuthUserUpdated extends AuthState {
  late final UserModel userModel;

  AuthUserUpdated({required this.userModel});

}
