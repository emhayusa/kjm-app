import 'package:equatable/equatable.dart';
//import 'package:kjm_app/models/user_profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class FetchProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  //final UserProfile userProfile;

  //const UpdateProfile({required this.userProfile});

  //@override
  //List<Object> get props => [userProfile];
}

class ProfileButtonPressed extends ProfileEvent {
  final String username;
  final String email;
  final String phone;
  final String password;

  const ProfileButtonPressed(
      {required this.username,
      required this.email,
      required this.phone,
      required this.password});

  @override
  List<Object> get props => [username, email, phone, password];
}
