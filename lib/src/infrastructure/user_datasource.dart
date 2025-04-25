import 'package:i18nizely/shared/data/remote/network_service.dart';
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
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to get users.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.getUsers',
            ),
          );
        }

        final List<User> users = [];
        for (var user in response.data) {
          users.add(User.fromJson(user));
        }
        return Right(users);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
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
      },
      (response) async {
        if (response.statusCode != 201) {
          return Left(
            AppException(
              message: 'Failed to create user.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.createUser',
            ),
          );
        }

        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
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
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to get user.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.getUser',
            ),
          );
        }

        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
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
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to update user.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.updateUser',
            ),
          );
        }

        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.updateUser',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> changeUserImage({required int id, required String pathImage}) async {
    // TODO: implement changeUserImage
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, void>> deleteUser({required int id}) async {
    try {
      final eitherType = await networkService.delete('users/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 204) {
          return Left(
            AppException(
              message: 'Failed to delete user.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.deleteUser',
            ),
          );
        }
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
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
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to get profile.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.getProfile',
            ),
          );
        }

        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
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
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to update profile.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.updateProfile',
            ),
          );
        }

        final User user = User.fromJson(response.data);
        return Right(user);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.updateProfile',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> changeProfileImage({required String pathImage}) async {
    // TODO: implement changeProfileImage
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, void>> deleteProfile() async {
    try {
      final eitherType = await networkService.delete('users/profile/');
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 204) {
          return Left(
            AppException(
              message: 'Failed to delete profile.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.deleteProfile',
            ),
          );
        }
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.deleteProfile',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<Notification>>> getNotifications() async {
    try {
      final eitherType = await networkService.get('notifications/');
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to get notifications.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.getNotifications',
            ),
          );
        }

        final List<Notification> notifications = [];
        for (var notification in response.data) {
          notifications.add(Notification.fromJson(notification));
        }
        return Right(notifications);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
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
      },
      (response) async {
        if (response.statusCode != 204) {
          return Left(
            AppException(
              message: 'Failed to delete notification.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'UserApiDataSource.deleteNotification',
            ),
          );
        }
        return Right(null);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'UserApiDataSource.deleteNotification',
        ),
      );
    }
  }
}