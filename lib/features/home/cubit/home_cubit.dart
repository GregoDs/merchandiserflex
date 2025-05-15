// Tells the kitchen what to cook, how to coook it and tells the customer when the food is ready

import 'package:flexmerchandiser/exports.dart';
import 'package:flexmerchandiser/features/home/cubit/home_state.dart';
import 'package:flexmerchandiser/features/home/repo/home_repo.dart';
import 'package:flexmerchandiser/features/home/models/outlets_model.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  //Start when in the Initialized state
  HomeCubit(this.homeRepo) : super(HomeInitial());

  Future<void> fetchOutlets() async {
    emit(HomeLoading());

    try {
      final List<Outlet> outlets = await homeRepo.fetchOutlets();
      emit(HomeSuccess(outlets));
    } on DioException catch (dioError) {
      //use the Kitchen manual to explain
      final message = ErrorHandler.handleError(dioError);
      emit(HomeError(message));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
