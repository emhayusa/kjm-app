import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:kjm_app/models/user_profile.dart';
import 'package:kjm_app/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  void _onFetchProfile(FetchProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      //final UserProfile userProfile = await profileRepository.fetchProfile();
      //emit(ProfileLoaded(userProfile: userProfile));
    } catch (error) {
      emit(ProfileError(message: error.toString()));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdating());
    try {
      //await profileRepository.updateProfile(event.userProfile);
      //emit(ProfileUpdated());
    } catch (error) {
      emit(ProfileError(message: error.toString()));
    }
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      /*
      //final profilePictureUrl = await userRepository.fetchProfilePicture();
      final profileData = await profileRepository.fetchProfileData();
      final profileNameFromPreferences =
          await profileRepository.getProfileNameFromPreferences();
      emit(ProfileLoaded(
        
        profilePictureUrl: profileData['profilePictureUrl']!,
        profileName: profileNameFromPreferences ?? profileData['profileName']!,
      ));
      //emit(ProfileLoaded(profilePictureUrl: profilePictureUrl));
      */
      //final UserProfile userProfile = await profileRepository.fetchProfile();
      //emit(ProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
  /*
  void _onProfileButtonPressed(
      ProfileButtonPressed event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final result = await userRepository.register(
        username: event.username,
        password: event.password,
        email: event.email,
        phone: event.phone,
      );
      if (result['status'] == 'success') {
        emit(ProfileSuccess(phone: event.phone, message: result['message']));
      } else {
        emit(ProfileFailure(error: result['message']));
      }
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }
  */
}
