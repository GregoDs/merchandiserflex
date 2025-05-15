import 'package:flexmerchandiser/features/customers/models/customers_model.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class CustomersState {
  const CustomersState();
}

final class CustomersInitial extends CustomersState {
  const CustomersInitial();
}

final class CustomersLoading extends CustomersState {
  const CustomersLoading();
}

final class CustomersSuccess extends CustomersState {
  final List<Customer> customers;
  final int currentPage;
  final int totalPages;
  const CustomersSuccess(this.customers, {required this.currentPage, required this.totalPages});
}

final class CustomersError extends CustomersState {
  final String message;
  const CustomersError(this.message);
}
