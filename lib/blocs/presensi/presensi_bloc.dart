import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_security/model/response/presensi_response_model.dart';
//import 'package:kjm_security/models/user_profile.dart';
import 'package:kjm_security/repositories/presensi_repository.dart';
import 'presensi_event.dart';
import 'presensi_state.dart';

class PresensiBloc extends Bloc<PresensiEvent, PresensiState> {
  final PresensiRepository presensiRepository;

  PresensiBloc({required this.presensiRepository}) : super(PresensiInitial()) {
    on<FetchPresensis>(_onFetchPresensis);
    on<FilterPresensis>(_onFilterPresensis);
    on<PostPresensiDatang>(_onPostPresensiDatang);
    on<PostPresensiPulang>(_onPostPresensiPulang);
  }

  Future<void> _onFetchPresensis(
      FetchPresensis event, Emitter<PresensiState> emit) async {
    emit(PresensiLoading());
    try {
      //final contact = await faqRepository.fetchContact();
      //emit(FaqLoaded(contact: contact));
      final List<PresensiResponseModel> presensis =
          await presensiRepository.fetchPresensis();
      emit(PresensiLoaded(presensis: presensis, filteredPresensis: presensis));
    } catch (e) {
      emit(PresensiError(message: e.toString()));
    }
  }

  void _onFilterPresensis(FilterPresensis event, Emitter<PresensiState> emit) {
    if (state is PresensiLoaded) {
      final currentState = state as PresensiLoaded;
      final filteredPresensis = currentState.presensis
          .where((presensi) => presensi.email
              .toLowerCase()
              .contains(event.filterText.toLowerCase()))
          .toList();
      emit(PresensiLoaded(
          presensis: currentState.presensis,
          filteredPresensis: filteredPresensis));
    }
  }

  void _onPostPresensiDatang(
      PostPresensiDatang event, Emitter<PresensiState> emit) async {
    emit(PresensiSending());
    try {
      final result = await presensiRepository.postPresensiDatang(
          event.presensiDatang, event.image);

      if (result['status'] == 'success') {
        emit(PresensiSuccess(message: result['message']));
      } else {
        emit(PresensiError(message: result['message']));
      }
      //await presensiRepository.postPresensiDatang(
      //    event.presensiDatang, event.image);
      //emit(PresensiPosted());
      //final List<PresensiResponseModel> presensis =
      //    await presensiRepository.fetchPresensis();
      //emit(PresensiLoaded(presensis: presensis, filteredPresensis: presensis));
    } catch (error) {
      emit(PresensiError(message: error.toString()));
    }
  }

  void _onPostPresensiPulang(
      PostPresensiPulang event, Emitter<PresensiState> emit) async {
    emit(PresensiSending());
    try {
      final result = await presensiRepository.postPresensiPulang(
          event.presensiPulang, event.image);

      if (result['status'] == 'success') {
        emit(PresensiSuccess(message: result['message']));
      } else {
        emit(PresensiError(message: result['message']));
      }
      //await presensiRepository.postPresensiDatang(
      //    event.presensiDatang, event.image);
      //emit(PresensiPosted());
      //final List<PresensiResponseModel> presensis =
      //    await presensiRepository.fetchPresensis();
      //emit(PresensiLoaded(presensis: presensis, filteredPresensis: presensis));
    } catch (error) {
      emit(PresensiError(message: error.toString()));
    }
  }
}
