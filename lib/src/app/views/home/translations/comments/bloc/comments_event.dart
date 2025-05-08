import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/comment_model.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object?> get props => [];
}

class GetComments extends CommentsEvent {
  final int projectId;
  final int keyId;
  final int translationId;

  const GetComments({required this.projectId, required this.keyId, required this.translationId});

  @override
  List<Object?> get props => [projectId, keyId, translationId];
}

class CreateComment extends CommentsEvent {
  final Comment newComment;

  const CreateComment({required this.newComment});

  @override
  List<Object?> get props => [newComment];
}

class UpdateComment extends CommentsEvent {
  final Comment newComment;

  const UpdateComment({required this.newComment});

  @override
  List<Object?> get props => [newComment];
}

class DeleteComment extends CommentsEvent {
  final int id;

  const DeleteComment({required this.id});

  @override
  List<Object?> get props => [id];
}

class ResetComments extends CommentsEvent {
  const ResetComments();
}