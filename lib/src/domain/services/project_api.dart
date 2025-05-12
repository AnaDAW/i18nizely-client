import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/record_model.dart' as r;

abstract class ProjectApi {
  Future<Either<AppException, List<Project>>> getProjects({String? name, int page = 1});

  Future<Either<AppException, List<Project>>> getCollabProjects({String? name, int page = 1});
  
  Future<Either<AppException, Project>> createProject({required Project newProject, required List<String> languages});
  
  Future<Either<AppException, Project>> getProject({required int id});
  
  Future<Either<AppException, Project>> updateProject({required Project newProject, List<String>? languages});
  
  Future<Either<AppException, void>> deleteProject({required int id});
  
  Future<Either<AppException, Collaborator>> addCollaborator({required int projectId, required Collaborator newCollaborator});
  
  Future<Either<AppException, Collaborator>> updateCollaborator({required int projectId, required int id, required List<CollabRole> roles});
  
  Future<Either<AppException, void>> removeCollaborator({required int projectId, required int id});
  
  Future<Either<AppException, List<r.Record>>> getRecord({required int projectId});
}