import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_app/blocs/profile/profile_bloc.dart';
import 'package:kjm_app/blocs/profile/profile_event.dart';
import 'package:kjm_app/blocs/profile/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileBloc>().add(FetchProfile());
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            //final userProfile = "";
            //state.userProfile;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('Name: ${userProfile.firstname}'),
                  //Text('Address: ${userProfile.address}'),
                  //Text('Phone: ${userProfile.phone}'),
                  //Text('Email: ${userProfile.email}'),
                  //Text('WhatsApp: ${userProfile.username}'),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
