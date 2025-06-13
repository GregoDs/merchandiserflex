// customers_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flexmerchandiser/features/customers/cubit/customers_state.dart';
import 'package:flexmerchandiser/features/customers/repo/customers_repo.dart';
import 'package:flexmerchandiser/utils/services/error_handler.dart';

class CustomersCubit extends Cubit<CustomersState> {
  final CustomerRepo _customerRepo;

  bool _hasReachedMax = false;
  int _currentPage = 1;

  // Store last search params
  String? _lastCustomerName;
  String? _lastPhone;
  String? _lastIsFlexsaveCustomer;
  String? _lastCustomerFollowup;
  String? _lastUserId;
  String? _lastOutletId;

  int _lastPage = 1;

  CustomersCubit(this._customerRepo) : super(CustomersInitial());

  Future<void> fetchCustomers({
  required String outletId,
  int page = 1,
  bool refresh = false,
}) async {
  try {
    if (_lastOutletId != outletId || refresh) {
      _lastOutletId = outletId;
      _lastPage = 1;
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
    if (_lastOutletId != null) {
      await fetchCustomers(outletId: _lastOutletId!, refresh: true);
    }
  }

  Future<void> searchCustomers({
    required String userId,
    required String outletId,
    int page = 1,
    String? customerName,
    String? phone,
    String? isFlexsaveCustomer,
    String? customerFollowup,
  }) async {
    emit(CustomersLoading());
    try {
      // Store last search params
      _lastUserId = userId;
      _lastOutletId = outletId;
      _lastCustomerName = customerName;
      _lastPhone = phone;
      _lastIsFlexsaveCustomer = isFlexsaveCustomer;
      _lastCustomerFollowup = customerFollowup;
      _lastPage = page;

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

  // Call this to fetch a specific page with the last search filters
  Future<void> fetchPage(int page) async {
    if (_lastUserId == null || _lastOutletId == null) return;
    await searchCustomers(
      userId: _lastUserId!,
      outletId: _lastOutletId!,
      page: page,
      customerName: _lastCustomerName,
      phone: _lastPhone,
      isFlexsaveCustomer: _lastIsFlexsaveCustomer,
      customerFollowup: _lastCustomerFollowup,
    );
  }
}
