import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/record_model.dart' as r;

abstract class ProjectApi {
  Future<Either<AppException, List<Project>>> getProjects({String? name});
  
  Future<Either<AppException, Project>> createProject({required Project newProject});
  
  Future<Either<AppException, Project>> getProject({required int id});
  
  Future<Either<AppException, Project>> updateProject({required Project newProject});
  
  Future<Either<AppException, void>> deleteProject({required int id});
  
  Future<Either<AppException, Collaborator>> addCollaborator({required int projectId, required Collaborator newCollaborator});
  
  Future<Either<AppException, Collaborator>> updateCollaborator({required int projectId, required int id, required List<Role> roles});
  
  Future<Either<AppException, void>> removeCollaborator({required int projectId, required int id});
  
  Future<Either<AppException, List<r.Record>>> getRecord({required int projectId});
}