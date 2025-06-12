import 'package:flexmerchandiser/features/chama/models/chama_subscription_model.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ChamaSubscriptionState {
  const ChamaSubscriptionState();
}

final class ChamaSubscriptionInitial extends ChamaSubscriptionState {
  const ChamaSubscriptionInitial();
}

final class ChamaSubscriptionLoading extends ChamaSubscriptionState {
  const ChamaSubscriptionLoading();
}

final class ChamaSubscriptionSuccess extends ChamaSubscriptionState {
  final ChamaSubscriptionResponse response;
  const ChamaSubscriptionSuccess(this.response);
}

final class ChamaSubscriptionError extends ChamaSubscriptionState {
  final String message;
  const ChamaSubscriptionError(this.message);
}
