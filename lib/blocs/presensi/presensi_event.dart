import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:kjm_app/model/request/presensi_request_model.dart';
//import 'package:kjm_app/models/user_Presensi.dart';

abstract class PresensiEvent extends Equatable {
  const PresensiEvent();

  @override
  List<Object> get props => [];
}

class FetchPresensis extends PresensiEvent {}

class FilterPresensis extends PresensiEvent {
  final String filterText;

  const FilterPresensis(this.filterText);

  @override
  List<Object> get props => [filterText];
}

class PostPresensiDatang extends PresensiEvent {
  final PresensiRequestModel presensiDatang;
  final File? image;

  const PostPresensiDatang({required this.presensiDatang, this.image});

  @override
  List<Object> get props => [presensiDatang, image != null];
}

class PostPresensiPulang extends PresensiEvent {
  final PresensiRequestModel presensiPulang;
  final File? image;

  const PostPresensiPulang({required this.presensiPulang, this.image});

  @override
  List<Object> get props => [presensiPulang, image != null];
}
/*
class PresensiButtonPressed extends PresensiEvent {
  final String username;
  final String email;
  final String phone;
  final String password;

  const PresensiButtonPressed(
      {required this.username,
      required this.email,
      required this.phone,
      required this.password});

  @override
  List<Object> get props => [username, email, phone, password];
}
*/
