import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfile extends ProfileEvent {
  const GetProfile();
}

class UpdateProfile extends ProfileEvent {
  final User newProfile;
  final String? password;

  const UpdateProfile({required this.newProfile, this.password});

  @override
  List<Object?> get props => [newProfile, password];
}

class ChangeProfileImage extends ProfileEvent {
  final String pathImage;

  const ChangeProfileImage(this.pathImage);

  @override
  List<Object?> get props => [pathImage];
}

class DeleteProfile extends ProfileEvent {
  const DeleteProfile();
}