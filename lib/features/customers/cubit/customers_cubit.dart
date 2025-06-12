// customers_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flexmerchandiser/features/customers/cubit/customers_state.dart';
import 'package:flexmerchandiser/features/customers/repo/customers_repo.dart';
import 'package:flexmerchandiser/utils/services/error_handler.dart';

class CustomersCubit extends Cubit<CustomersState> {
  final CustomerRepo _customerRepo;
  String? _currentOutletId;
  bool _hasReachedMax = false;
  int _currentPage = 1;

  CustomersCubit({required CustomerRepo customerRepo})
    : _customerRepo = customerRepo,
      super(const CustomersInitial());

  Future<void> fetchCustomers({
  required String outletId,
  int page = 1,
  bool refresh = false,
}) async {
  try {
    if (_currentOutletId != outletId || refresh) {
      _currentOutletId = outletId;
      _currentPage = 1;
    }
    // Always reset _hasReachedMax when a new page is requested
    _hasReachedMax = false;

    if (_hasReachedMax && !refresh) return;

    if (page == 1 || refresh) {
      emit(const CustomersLoading());
    }

    final customerData = await _customerRepo.fetchCustomers(
      outletId: outletId,
      page: page,
    );

    final totalPages = customerData.pagination.lastPage;
    final currentPage = page;

    emit(
      CustomersSuccess(
        customerData.customers,
        currentPage: currentPage,
        totalPages: totalPages,
      ),
    );

    if (customerData.pagination.nextPageUrl == null) {
      _hasReachedMax = true;
    } else {
      _currentPage = currentPage + 1;
    }
  } on DioException catch (dioError) {
    final message = ErrorHandler.handleError(dioError);
    emit(CustomersError(message));
  } catch (e) {
    emit(CustomersError(e.toString()));
  }
}

  Future<void> refreshCustomers() async {
    if (_currentOutletId != null) {
      await fetchCustomers(outletId: _currentOutletId!, refresh: true);
    }
  }

  Future<void> searchCustomers({
    required String outletId,
    required String userId,
    int page = 1,
    String? customerName,
    String? phone,
    String? isFlexsaveCustomer,
    String? customerFollowup,
  }) async {
    emit(CustomersLoading());
    try {
      final data = await _customerRepo.searchCustomers(
        userId: userId,
        outletId: outletId,
        page: page,
        customerName: customerName,
        phone: phone,
        isFlexsaveCustomer: isFlexsaveCustomer,
        customerFollowup: customerFollowup,
      );
      emit(CustomersSuccess(
        data.customers,
        currentPage: data.pagination.from,
        totalPages: data.pagination.lastPage,
      ));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }
}
