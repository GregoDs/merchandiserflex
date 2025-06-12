import 'package:bloc/bloc.dart';
import '../models/leads_model.dart';
import '../repo/leads_repo.dart';
import 'leads_state.dart';

class LeadsCubit extends Cubit<LeadsState> {
  final LeadsRepo leadsRepo;
  LeadsCubit(this.leadsRepo) : super(const LeadsInitial());

  Future<void> createLead(LeadRequest request) async {
    emit(const LeadsLoading());
    try {
      final response = await leadsRepo.createLead(request);
      emit(LeadsSuccess(response));
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }
}