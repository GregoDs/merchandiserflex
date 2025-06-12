import 'package:flutter/foundation.dart';
import '../models/leads_model.dart';

@immutable
sealed class LeadsState {
  const LeadsState();
}

class LeadsInitial extends LeadsState {
  const LeadsInitial();
}

class LeadsLoading extends LeadsState {
  const LeadsLoading();
}

class LeadsSuccess extends LeadsState {
  final LeadResponse lead;
  const LeadsSuccess(this.lead);
}

class LeadsError extends LeadsState {
  final String message;
  const LeadsError(this.message);
}