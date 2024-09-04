import 'package:equatable/equatable.dart';
//import 'package:kjm_security/models/user_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  /*final String profilePictureUrl;
  final String profileName;

  const ProfileLoaded(
      {required this.profilePictureUrl, required this.profileName});

  @override
  List<Object> get props => [profilePictureUrl, profileName];
  */
  //final UserProfile userProfile;

  //const ProfileLoaded({required this.userProfile});

  //@override
  //List<Object> get props => [userProfile];
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}
