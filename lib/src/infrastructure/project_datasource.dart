import 'package:i18nizely/shared/data/remote/network_service.dart';
import 'package:i18nizely/shared/exception/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/model/project_model.dart';
import 'package:i18nizely/src/domain/model/record_model.dart' as r;
import 'package:i18nizely/src/domain/service/project_api.dart';

class ProjectApiDataSource implements ProjectApi {
  final NetworkService networkService;

  const ProjectApiDataSource(this.networkService);

  @override
  Future<Either<AppException, List<Project>>> getProjects({String? name}) async {
    try {
      final eitherType = await networkService.get('projects/', queryParameters: name != null ? { 'name': name } : null);
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to get projects.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'ProjectApiDataSource.getProjects',
            ),
          );
        }

        final List<Project> projects = response.data.map((project) => Project.fromJson(project)).toList();
        return Right(projects);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.getProjects',
        ),
      );
    }
  }
  
  @override
  Future<Either<AppException, Project>> createProject({required Project newProject}) async {
    try {
      final eitherType = await networkService.post('projects/', data: newProject.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 201) {
          return Left(
            AppException(
              message: 'Failed to create project.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'ProjectApiDataSource.createProject',
            ),
          );
        }

        final Project project = Project.fromJson(response.data);
        return Right(project);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.createProject',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Project>> getProject({required int id}) async {
    try {
      final eitherType = await networkService.get('projects/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to get project.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'ProjectApiDataSource.getProject',
            ),
          );
        }

        final Project project = Project.fromJson(response.data);
        return Right(project);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.getProject',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Project>> updateProject({required Project newProject}) async {
    try {
      final eitherType = await networkService.patch('projects/${newProject.id}/', data: newProject.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to update project.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'ProjectApiDataSource.updateProject',
            ),
          );
        }

        final Project project = Project.fromJson(response.data);
        return Right(project);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.updateProject',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> deleteProject({required int id}) async {
    try {
      final eitherType = await networkService.delete('projects/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 204) {
          return Left(
            AppException(
              message: 'Failed to delete project.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'ProjectApiDataSource.deleteProject',
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
          identifier: 'ProjectApiDataSource.deleteProject',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Collaborator>> addCollaborator({required int projectId, required Collaborator newCollaborator}) async {
    try {
      final eitherType = await networkService.post('projects/$projectId/collaborators/', data: newCollaborator.toQueryMap());
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 201) {
          return Left(
            AppException(
              message: 'Failed to add collaborator.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'ProjectApiDataSource.addCollaborator',
            ),
          );
        }

        final Collaborator collaborator = Collaborator.fromJson(response.data);
        return Right(collaborator);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.addCollaborator',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Collaborator>> updateCollaborator({required int projectId, required int id, required List<Role> roles}) async {
    try {
      final eitherType = await networkService.patch('projects/$projectId/collaborators/$id/', data: { 'roles': roles });
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to update collaborator.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'ProjectApiDataSource.updateCollaborator',
            ),
          );
        }

        final Collaborator collaborator = Collaborator.fromJson(response.data);
        return Right(collaborator);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.updateCollaborator',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> removeCollaborator({required int projectId, required int id}) async {
    try {
      final eitherType = await networkService.delete('projects/$projectId/collaborators/$id/');
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 204) {
          return Left(
            AppException(
              message: 'Failed to remove collaborator.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'ProjectApiDataSource.removeCollaborator',
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
          identifier: 'ProjectApiDataSource.removeCollaborator',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<Record>>> getRecord({required int projectId}) async {
    try {
      final eitherType = await networkService.get('projects/$projectId/record/');
      return eitherType.fold((exception) {
        return Left(exception);
      },
      (response) async {
        if (response.statusCode != 200) {
          return Left(
            AppException(
              message: 'Failed to get record.\nStatus: ${response.statusMessage}.\nResponse: ${response.data}',
              statusCode: response.statusCode,
              identifier: 'ProjectApiDataSource.getRecord',
            ),
          );
        }

        List<Record> record = response.data.map((rec) => r.Record.fromJson(rec)).toList();
        return Right(record);
      });
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.getRecord',
        ),
      );
    }
  }
}