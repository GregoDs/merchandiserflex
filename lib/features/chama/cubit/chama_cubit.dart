import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_state.dart';
import 'package:flexmerchandiser/features/chama/repo/chama_repo.dart';
import 'package:flexmerchandiser/utils/services/error_handler.dart';

class ChamaCubit extends Cubit<ChamaState> {
  final ChamaRepo _chamaRepo;

  ChamaCubit({required ChamaRepo chamaRepo})
    : _chamaRepo = chamaRepo,
      super(const ChamaInitial());

  Future<void> registerCustomer({
    required String phoneNumber,
    required String dob,
    required String firstName,
    required String lastName,
    required String gender,
    required String idNumber,
    required int agentId,
  }) async {
    try {
      emit(const ChamaLoading());

      final response = await _chamaRepo.registerCustomer(
        phoneNumber: phoneNumber,
        dob: dob,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        idNumber: idNumber,
        agentId: agentId,
      );

      emit(ChamaSuccess(response));
    } on DioException catch (dioError) {
      final message = ErrorHandler.handleError(dioError);
      emit(ChamaError(message));
    } catch (e) {
      emit(ChamaError(e.toString()));
    }
  }
}
