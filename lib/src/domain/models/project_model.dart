import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

class Project extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final User? createdBy;
  final String? mainLanguage;
  final List<String>? languages;
  final List<Collaborator>? collaborators;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Project({
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.mainLanguage,
    this.languages,
    this.collaborators,
    this.createdAt,
    this.updatedAt
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    List<Collaborator> collaboratorList = [];
    if (json['collaborators'] != null) {
      for (Map<String, dynamic> collaborator in json['collaborators']) {
        collaboratorList.add(Collaborator.fromJson(collaborator));
      }
    }

    List<String> languageList = [];
    if (json['languages'] != null) {
      for (String language in json['languages']) {
        languageList.add(language);
      }
    }

    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['created_by'] != null ? User.fromJson(json['created_by']) : null,
      mainLanguage: json['main_language'],
      languages: languageList,
      collaborators: collaboratorList,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    createdBy,
    mainLanguage,
    languages,
    collaborators,
    createdAt,
    updatedAt
  ];

  Map<String, dynamic>  toQueryMap() {
    Map<String, dynamic> map = {};
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    if (mainLanguage != null) map['main_language'] = mainLanguage;
    if (languages != null) map['languages'] = languages;
    return map;
  }

  Project copyWith({
    int? id,
    String? name,
    String? description,
    User? createdBy,
    String? mainLanguage,
    List<String>? languages,
    List<Collaborator>? collaborators,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      mainLanguage: mainLanguage ?? this.mainLanguage,
      languages: languages ?? this.languages,
      collaborators: collaborators ?? this.collaborators,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt
    );
  }
}

enum CollabRole { admin, developer, reviewer, translator }

class Collaborator extends Equatable {
  final int? id;
  final User user;
  final List<CollabRole> roles;

  const Collaborator({
    this.id,
    required this.user,
    required this.roles
  });

  factory Collaborator.fromJson(Map<String, dynamic> json) {
    List<CollabRole> roleList = [];
    for (var role in json['roles']) {
      roleList.add(CollabRole.values[role - 1]);
    }

    return Collaborator(
      id: json['id'],
      user: User.fromJson(json['user']),
      roles: roleList
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    roles
  ];

  Map<String, dynamic> toQueryMap() {
    return {'user': user.id, 'roles': roles.map((role) => role.index + 1).toList()};
  }
}