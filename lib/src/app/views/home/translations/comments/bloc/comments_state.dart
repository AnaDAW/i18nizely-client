import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/comment_model.dart';

class CommentsState extends Equatable {

  const CommentsState();

  @override
  List<Object?> get props => [];
}

class CommentsInitial extends CommentsState {
  const CommentsInitial();
}

class CommentsLoading extends CommentsState {
  const CommentsLoading();
}

class CommentsLoaded extends CommentsState {
  final int projectId;
  final int keyId;
  final int translationId;
  final List<Comment> comments;

  const CommentsLoaded(this.comments, {required this.projectId, required this.keyId, required this.translationId});

  @override
  List<Object?> get props => [comments, projectId, keyId, translationId];
}

class CommentsError extends CommentsState {
  final dynamic data;

  const CommentsError(this.data);

  @override
  List<Object?> get props => [data];
}

class CommentCreated extends CommentsLoaded {
  const CommentCreated(super.comments, {required super.projectId, required super.keyId, required super.translationId});
}

class CommentCreateError extends CommentsLoaded {
  final dynamic data;

  const CommentCreateError(super.comments, {required this.data, required super.projectId, required super.keyId, required super.translationId});

  @override
  List<Object?> get props => [comments, data, projectId, keyId, translationId];
}

class CommentUpdated extends CommentsLoaded {
  const CommentUpdated(super.comments, {required super.projectId, required super.keyId, required super.translationId});
}

class CommentUpdateError extends CommentsLoaded {
  final dynamic data;

  const CommentUpdateError(super.comments, {required this.data, required super.projectId, required super.keyId, required super.translationId});

  @override
  List<Object?> get props => [comments, data, projectId, keyId, translationId];
}

class CommentDeleted extends CommentsLoaded {
  const CommentDeleted(super.comments, {required super.projectId, required super.keyId, required super.translationId});
}

class CommentDeleteError extends CommentsLoaded {
  final dynamic data;

  const CommentDeleteError(super.comments, {required this.data, required super.projectId, required super.keyId, required super.translationId});

  @override
  List<Object?> get props => [comments, data, projectId, keyId, translationId];
}