import 'package:i18nizely/shared/exception/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/model/notification_model.dart';
import 'package:i18nizely/src/domain/model/user_model.dart';

abstract class UserApi {
  Future<Either<AppException, List<User>>> getUsers({ String? name });
  
  Future<Either<AppException, User>> createUser({ required User newUser, required String password });
  
  Future<Either<AppException, User>> getUser({ required int id });
  
  Future<Either<AppException, User>> updateUser({ required User newUser });
  
  Future<Either<AppException, User>> changeUserImage({ required int id, required String pathImage });
  
  Future<Either<AppException, void>> deleteUser({ required int id });
  
  Future<Either<AppException, User>> getProfile();
  
  Future<Either<AppException, User>> updateProfile({ required User newProfile });
  
  Future<Either<AppException, User>> changeProfileImage({ required String pathImage });
  
  Future<Either<AppException, void>> deleteProfile();
  
  Future<Either<AppException, List<Notification>>> getNotifications();
  
  Future<Either<AppException, void>> deleteNotification({ required int id });
}