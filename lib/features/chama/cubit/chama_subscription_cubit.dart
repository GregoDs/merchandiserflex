import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_subscription_state.dart';
import 'package:flexmerchandiser/features/chama/repo/chama_repo.dart';
import 'package:flexmerchandiser/utils/services/error_handler.dart';

class ChamaSubscriptionCubit extends Cubit<ChamaSubscriptionState> {
  final ChamaRepo _chamaRepo;

  ChamaSubscriptionCubit({required ChamaRepo chamaRepo})
    : _chamaRepo = chamaRepo,
      super(const ChamaSubscriptionInitial());

  Future<void> subscribeToChama({
    required String phoneNumber,
    required int productId,
    required double depositAmount,
  }) async {
    try {
      emit(const ChamaSubscriptionLoading());
      final response = await _chamaRepo.subscribeToChama(
        phoneNumber: phoneNumber,
        productId: productId,
        depositAmount: depositAmount,
      );
      if (response.success) {
        emit(ChamaSubscriptionSuccess(response));
      } else {
        emit(ChamaSubscriptionError(response.errors.join(', ')));
      }
    } on DioException catch (dioError) {
      final message = ErrorHandler.handleError(dioError);
      emit(ChamaSubscriptionError(message));
    } catch (e) {
      emit(ChamaSubscriptionError(e.toString()));
    }
  }
}
