import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_products_state.dart';
import 'package:flexmerchandiser/features/chama/repo/chama_repo.dart';
import 'package:flexmerchandiser/utils/services/error_handler.dart';

class ChamaProductsCubit extends Cubit<ChamaProductsState> {
  final ChamaRepo _chamaRepo;

  ChamaProductsCubit({required ChamaRepo chamaRepo})
    : _chamaRepo = chamaRepo,
      super(const ChamaProductsInitial());

  Future<void> fetchProducts(String type) async {
    try {
      emit(const ChamaProductsLoading());
      final response = await _chamaRepo.fetchChamaProducts(type);
      if (response.success) {
        emit(ChamaProductsSuccess(response.data));
      } else {
        emit(ChamaProductsError(response.errors.join(', ')));
      }
    } on DioException catch (dioError) {
      final message = ErrorHandler.handleError(dioError);
      emit(ChamaProductsError(message));
    } catch (e) {
      emit(ChamaProductsError(e.toString()));
    }
  }
}
