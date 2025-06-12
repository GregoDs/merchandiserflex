import 'package:flexmerchandiser/features/chama/models/chama_registration_model.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ChamaState {
  const ChamaState();
}

final class ChamaInitial extends ChamaState {
  const ChamaInitial();
}

final class ChamaLoading extends ChamaState {
  const ChamaLoading();
}

final class ChamaSuccess extends ChamaState {
  final ChamaRegistrationResponse response;
  const ChamaSuccess(this.response);
}

final class ChamaError extends ChamaState {
  final String message;
  const ChamaError(this.message);
}
