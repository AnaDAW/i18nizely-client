import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

class Project extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final User? createdBy;
  final String? mainLanguage;
  final List<String>? languages;
  final List<Collaborator>? collaborators;
  final List<Key>? keys;
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
    this.keys,
    this.createdAt,
    this.updatedAt
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    List<Collaborator> collaboratorList = [];
    for (Map<String, dynamic> collaborator in json['collaborators']) {
      collaboratorList.add(Collaborator.fromJson(collaborator));
    }

    List<Key> keyList = [];
    for (Map<String, dynamic> key in json['keys']) {
      keyList.add(Key.fromJson(key));
    }

    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: User.fromJson(json['created_by']),
      mainLanguage: json['main_language'],
      languages: json['languages'],
      collaborators: collaboratorList,
      keys: keyList,
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
    createdAt,
    updatedAt
  ];

  Map<String, dynamic>  toQueryMap() {
    Map<String, dynamic> map = {};
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    if (languages != null) map['languages'] = languages;
    return map;
  }
}

enum Role { admin, developer, reviewer, translator }

class Collaborator extends Equatable {
  final int? id;
  final User user;
  final List<Role> roles;

  const Collaborator({
    this.id,
    required this.user,
    required this.roles
  });

  factory Collaborator.fromJson(Map<String, dynamic> json) {
    return Collaborator(
      id: json['id'],
      user: User.fromJson(json['user']),
      roles: json['roles']
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    roles
  ];

  Map<String, dynamic>  toQueryMap() {
    return {'user': user, 'roles': roles};
  }
}