import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';

abstract class AuthApi {
  Future<Either<AppException, void>> login({required String email, required String password});
  
  Future<Either<AppException, void>> refresh();

  Future<void> logout();

  Future<bool> isLogged();
}