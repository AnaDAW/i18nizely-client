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
  Future<Either<AppException, Map<String, dynamic>>> getProjects({String? name, int page = 1}) async {
    try {
      return getAllProjects(endpoint: 'projects/', name: name, page: page);
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.getProjects',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Map<String, dynamic>>> getCollabProjects({String? name, int page = 1}) async {
    try {
      return getAllProjects(endpoint: 'projects/collab/', name: name, page: page);
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.getCollabProjects',
        ),
      );
    }
  }

  Future<Either<AppException, Map<String, dynamic>>> getAllProjects({required String endpoint, String? name, int page = 1}) async {
    final Map<String, dynamic> queryParameters = {'page': page};
    if (name != null) queryParameters['name'] = name;

    final eitherType = await networkService.get(endpoint, queryParameters: queryParameters);
    return eitherType.fold((exception) {
      return Left(exception);
    }, (response) async {
      final List<Project> projects = [];
      for (var project in response.data['results'] ?? []) {
        projects.add(Project.fromJson(project));
      }

      int totalPages = ((response.data['count'] ?? 1) / 10).ceil();

      Map<String, dynamic> res = {'totalPages': totalPages == 0 ? 1 : totalPages, 'projects': projects};
      return Right(res);
    });
  }

  @override
  Future<Either<AppException, Project>> createProject({required Project newProject, required List<String> languages}) async {
    try {
      final eitherType = await networkService.post('projects/', data: {...newProject.toQueryMap(), 'language_codes': languages});
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final Project project = Project.fromJson(response.data);
        return Right(project);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
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
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.getProject',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Project>> updateProject({required Project newProject, List<String>? languages}) async {
    try {
      Map<String, dynamic> data = newProject.toQueryMap();
      if (languages != null) data['language_codes'] = languages;
      final eitherType = await networkService.patch('projects/${newProject.id}/', data: data);
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final Project project = Project.fromJson(response.data);
        return Right(project);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
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
          data: 'Unknown error occurred. Exception: ${e.toString()}',
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
        final Map<String, dynamic> user = {
          'id': response.data['user'],
          'first_name': newCollaborator.user.firstName,
          'last_name': newCollaborator.user.lastName,
          'image': newCollaborator.user.image
        };
        final Collaborator collaborator = Collaborator.fromJson({...response.data, 'user': user});
        return Right(collaborator);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.addCollaborator',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, Collaborator>> updateCollaborator({required int projectId, required int id, required List<CollabRole> roles}) async {
    try {
      final eitherType = await networkService.patch('projects/$projectId/collaborators/$id/', data: { 'roles': roles.map((role) => role.index + 1).toList() });
      return eitherType.fold((exception) {
        return Left(exception);
      }, (response) async {
        final Collaborator collaborator = Collaborator.fromJson(response.data);
        return Right(collaborator);
      });
    } catch (e) {
      return Left(
        AppException(
          data: 'Unknown error occurred. Exception: ${e.toString()}',
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
          data: 'Unknown error occurred. Exception: ${e.toString()}',
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
          data: 'Unknown error occurred. Exception: ${e.toString()}',
          statusCode: 500,
          identifier: 'ProjectApiDataSource.getRecord',
        ),
      );
    }
  }
}