import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_event.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_state.dart';
import 'package:i18nizely/src/domain/services/user_api.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserApi userApi;

  ProfileBloc(this.userApi) : super(const ProfileInitial()) {
    on<GetProfile>(_onGetProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ChangeProfileImage>(_onChangeProfileImage);
    on<DeleteProfileImage>(_onDeleteProfileImage);
    on<DeleteProfile>(_onDeleteProfile);
    on<ResetProfile>(_onResetProfile);
  }

  Future<void> _onGetProfile(GetProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      final res = await userApi.getProfile();
      res.fold((left) {
        emit(ProfileError(left.data));
      }, (right) {
        emit(ProfileLoaded(right));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    if (state is! ProfileLoaded) return;
    try {
      final res = await userApi.updateProfile(newProfile: event.newProfile, password: event.password);
      res.fold((left) {
        emit(ProfileUpdateError((state as ProfileLoaded).profile, left.data));
      }, (right) {
        emit(ProfileUpdated(right));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProfileUpdateError((state as ProfileLoaded).profile, e.toString()));
    }
  }

  Future<void> _onChangeProfileImage(ChangeProfileImage event, Emitter<ProfileState> emit) async {
    if (state is! ProfileLoaded) return;
    try {
      final res = await userApi.changeProfileImage(pathImage: event.pathImage);
      res.fold((left) {
        emit(ProfileUpdateError((state as ProfileLoaded).profile, left.data));
      }, (right) {
        emit(ProfileUpdated(right));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProfileUpdateError((state as ProfileLoaded).profile, e.toString()));
    }
  }

  Future<void> _onDeleteProfileImage(DeleteProfileImage event, Emitter<ProfileState> emit) async {
    if (state is! ProfileLoaded) return;
    try {
      final res = await userApi.deleteProfileImage();
      res.fold((left) {
        emit(ProfileUpdateError((state as ProfileLoaded).profile, left.data));
      }, (right) {
        emit(ProfileUpdated(right));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProfileUpdateError((state as ProfileLoaded).profile, e.toString()));
    }
  }

  Future<void> _onDeleteProfile(DeleteProfile event, Emitter<ProfileState> emit) async {
    if (state is! ProfileLoaded) return;
    try {
      final res = await userApi.deleteProfile();
      res.fold((left) {
        emit(ProfileDeleteError((state as ProfileLoaded).profile, left.data));
      }, (right) {
        emit(const ProfileDeleted());
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ProfileDeleteError((state as ProfileLoaded).profile, e.toString()));
    }
  }

  Future<void> _onResetProfile(ResetProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileInitial());
  }
}