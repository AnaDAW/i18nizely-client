import 'package:i18nizely/shared/domain/services/network_service.dart';
import 'package:i18nizely/shared/exceptions/http_exception.dart';
import 'package:i18nizely/shared/domain/models/either_model.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/record_model.dart' as r;
import 'package:i18nizely/src/domain/services/project_api.dart';

class ProjectApiDataSource implements ProjectApi {
  final NetworkService networkService;

  const ProjectApiDataSource(this.networkService);

  @override
  Future<Either<AppException, List<Project>>> getProjects({String? name, int page = 1}) async {
    try {
      final Map<String, dynamic> queryParameters = {'page': page};
      if (name != null) queryParameters['name'] = name;

      final eitherType = await networkService.get('projects/', queryParameters: queryParameters);
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final List<Project> projects = [];
        for (var project in response.data) {
          projects.add(Project.fromJson(project));
        }
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
  Future<Either<AppException, List<Project>>> getCollabProjects({String? name, int page = 1}) async {
    try {
      final Map<String, dynamic> queryParameters = {'page': page};
      if (name != null) queryParameters['name'] = name;

      final eitherType = await networkService.get('projects/collab/', queryParameters: queryParameters);
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final List<Project> projects = [];
        for (var project in response.data) {
          projects.add(Project.fromJson(project));
        }
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
      }, (response) async {
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
      }, (response) async {
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
      }, (response) async {
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
      }, (response) async {
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
      }, (response) async {
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
  Future<Either<AppException, Collaborator>> updateCollaborator({required int projectId, required int id, required List<CollabRole> roles}) async {
    try {
      final eitherType = await networkService.patch('projects/$projectId/collaborators/$id/', data: { 'roles': roles });
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
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
      }, (response) async {
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
  Future<Either<AppException, List<r.Record>>> getRecord({required int projectId}) async {
    try {
      final eitherType = await networkService.get('projects/$projectId/record/');
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final List<r.Record> record = [];
        for (var rec in response.data) {
          record.add(r.Record.fromJson(rec));
        }
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