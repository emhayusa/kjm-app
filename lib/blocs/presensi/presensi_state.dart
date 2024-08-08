import 'package:equatable/equatable.dart';
import 'package:kjm_app/model/response/presensi_response_model.dart';

//import 'package:kjm_app/models/user_Presensi.dart';
abstract class PresensiState extends Equatable {
  const PresensiState();

  @override
  List<Object> get props => [];
}

class PresensiInitial extends PresensiState {}

class PresensiLoading extends PresensiState {}

class PresensiLoaded extends PresensiState {
  final List<PresensiResponseModel> presensis;
  final List<PresensiResponseModel> filteredPresensis;

  const PresensiLoaded(
      {required this.presensis, required this.filteredPresensis});

  @override
  List<Object> get props => [presensis, filteredPresensis];
}

class PresensiError extends PresensiState {
  final String message;

  const PresensiError({required this.message});

  @override
  List<Object> get props => [message];
}

class PresensiSuccess extends PresensiState {
  final String message;

  const PresensiSuccess({required this.message});
}

class PresensiSending extends PresensiState {}

class PresensiPosted extends PresensiState {}
