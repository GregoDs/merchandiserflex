import 'package:flutter/foundation.dart';
import 'package:flexmerchandiser/features/home/models/outlets_model.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeSuccess extends HomeState {
  final List<Outlet> outlets;
  const HomeSuccess(this.outlets);
}

final class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
