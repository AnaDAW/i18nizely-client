import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final User profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdated extends ProfileLoaded {
  const ProfileUpdated(super.profile);
}

class ProfileUpdateError extends ProfileLoaded {
  final String message;

  const ProfileUpdateError(super.profile, this.message);

  @override
  List<Object?> get props => [message, profile];
}

class ProfileDeleted extends ProfileState {
  const ProfileDeleted();
}

class ProfileDeleteError extends ProfileLoaded {
  final String message;

  const ProfileDeleteError(super.profile, this.message);

  @override
  List<Object?> get props => [message, profile];
}