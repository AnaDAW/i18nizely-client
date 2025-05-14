import 'package:i18nizely/shared/domain/services/network_service.dart';
import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/notification_model.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';
import 'package:i18nizely/src/domain/services/user_api.dart';

class UserApiDataSource implements UserApi {
  final NetworkService networkService;

  const UserApiDataSource(this.networkService);
  
  @override
  Future<Either<AppException, List<User>>> getUsers({String? name}) async {
    try {
      final eitherType = await networkService.get('users/', queryParameters: name != null ? { 'name': name } : null);
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final List<User> users = [];
        for (var user in response.data) {
          users.add(User.fromJson(user));
        }
        return Right(users);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.getUsers',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> createUser({required User newUser, required String password}) async {
    try {
      final eitherType = await networkService.post('users/', data: {...newUser.toQueryMap(), 'password': password});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.createUser',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> getUser({required int id}) async {
    try {
      final eitherType = await networkService.get('users/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.getUser',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> updateUser({required User newUser, required String? password}) async {
    try {
      final Map<String, dynamic> data = newUser.toQueryMap();
      if (password != null) data['password'] = password;
      
      final eitherType = await networkService.patch('users/${newUser.id}/', data: data);
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.updateUser',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> changeUserImage({required int id, required String pathImage}) async {
    try {
      final eitherType = await networkService.updateFiles('users/$id/', files: {'image': pathImage});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.updateUser',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> deleteUserImage({required int id}) async {
    try {
      final eitherType = await networkService.patch('users/$id/', data: {'image': null});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.updateUser',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> deleteUser({required int id}) async {
    try {
      final eitherType = await networkService.delete('users/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.deleteUser',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> getProfile() async {
    try {
      final eitherType = await networkService.get('users/profile/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.getProfile',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> updateProfile({required User newProfile, required String? password}) async {
    try {
      final Map<String, dynamic> data = newProfile.toQueryMap();
      if (password != null) data['password'] = password;
      
      final eitherType = await networkService.patch('users/profile/', data: data);
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.updateProfile',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> changeProfileImage({required String pathImage}) async {
    try {
      final eitherType = await networkService.updateFiles('users/profile/', files: {'image': pathImage});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.updateProfile',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> deleteProfileImage() async {
    try {
      final eitherType = await networkService.patch('users/profile/', data: {'image': null});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.updateProfile',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> deleteProfile() async {
    try {
      final eitherType = await networkService.delete('users/profile/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.deleteProfile',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<AppNotification>>> getNotifications() async {
    try {
      final eitherType = await networkService.get('notifications/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final List<AppNotification> notifications = [];
        for (var notification in response.data) {
          notifications.add(AppNotification.fromJson(notification));
        }
        return Right(notifications);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.getNotifications',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> deleteNotification({required int id}) async {
    try {
      final eitherType = await networkService.delete('notifications/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.deleteNotification',
        ),
      );
    }
  }
}