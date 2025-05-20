import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/comments/bloc/comments_event.dart';
import 'package:i18nizely/src/app/views/home/translations/comments/bloc/comments_state.dart';
import 'package:i18nizely/src/domain/models/comment_model.dart';
import 'package:i18nizely/src/domain/services/translation_api.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final TranslationApi translationApi;

  CommentsBloc(this.translationApi) : super(const CommentsInitial()) {
    on<GetComments>(_onGetComments);
    on<CreateComment>(_onCreateComment);
    on<UpdateComment>(_onUpdateComment);
    on<DeleteComment>(_onDeleteComment);
    on<ResetComments>(_onResetComments);
  }

  Future<void> _onGetComments(GetComments event, Emitter<CommentsState> emit) async {
    emit(CommentsLoading());
    try {
      final res = await translationApi.getComments(projectId: event.projectId, keyId: event.keyId, translationId: event.translationId);
      res.fold((left) {
        emit(CommentsError(left.data));
      }, (right) {
        emit(CommentsLoaded(right, projectId: event.projectId, keyId: event.keyId, translationId: event.translationId));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CommentsError(e.toString()));
    }
  }

  Future<void> _onCreateComment(CreateComment event, Emitter<CommentsState> emit) async {
    if (state is! CommentsLoaded) return;
    CommentsLoaded loadedState = state as CommentsLoaded;
    try {
      final res = await translationApi.createComment(projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId, newComment: event.newComment);
      await res.fold((left) {
        emit(CommentCreateError(loadedState.comments, data: left.data, projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId));
      }, (right) async {
        final List<Comment> comments = List.of(loadedState.comments);
        comments.add(right);
        emit(CommentCreated(comments, projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId));
        //await _onGetComments(GetComments(projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CommentCreateError(loadedState.comments, data: e.toString(), projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId));
    }
  }

  Future<void> _onUpdateComment(UpdateComment event, Emitter<CommentsState> emit) async {
    if (state is! CommentsLoaded) return;
    CommentsLoaded loadedState = state as CommentsLoaded;
    try {
      final res = await translationApi.updateComment(projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId, newComment: event.newComment);
      await res.fold((left) {
        emit(CommentUpdateError(loadedState.comments, data: left.data, projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId));
      }, (right) async {
        final List<Comment> comments = List.of(loadedState.comments);
        final int index = comments.indexWhere((comment) => comment.id == event.newComment.id);
        if (index != -1) comments[index] = right;
        emit(CommentUpdated(comments, projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId));
        //await _onGetComments(GetComments(projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CommentUpdateError(loadedState.comments, data: e.toString(), projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId));
    }
  }

  Future<void> _onDeleteComment(DeleteComment event, Emitter<CommentsState> emit) async {
    if (state is! CommentsLoaded) return;
    CommentsLoaded loadedState = state as CommentsLoaded;
    try {
      final res = await translationApi.deleteComment(projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId, id: event.id);
      await res.fold((left) {
        emit(CommentDeleteError(loadedState.comments, data: left.data, projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId));
      }, (right) async {
        final List<Comment> comments = List.of(loadedState.comments);
        comments.removeWhere((comment) => comment.id == event.id);
        emit(CommentDeleted(comments, projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId));
        //await _onGetComments(GetComments(projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CommentDeleteError(loadedState.comments, data: e.toString(), projectId: loadedState.projectId, keyId: loadedState.keyId, translationId: loadedState.translationId));
    }
  }

  Future<void> _onResetComments(ResetComments event, Emitter<CommentsState> emit) async {
    emit(const CommentsInitial());
  }
}