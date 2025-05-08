import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_snackbar.dart';
import 'package:i18nizely/src/app/common/app_tab_item.dart';
import 'package:i18nizely/src/app/views/home/translations/comments/bloc/comments_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/comments/bloc/comments_event.dart';
import 'package:i18nizely/src/app/views/home/translations/comments/bloc/comments_state.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/comment_model.dart';

class CommentsTab extends StatelessWidget {
  final VoidCallback closeTab;

  const CommentsTab({super.key, required this.closeTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                IconButton(
                  onPressed: closeTab,
                  icon: Icon(Icons.close)
                ),
                Center(
                  child: Text(
                    'Comments',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<CommentsBloc, CommentsState>(
              listener: (context, state) {
                if (state is CommentCreated) {
                  AppSnackBar.showSnackBar(context, text: 'Comment created.');
                } else if (state is CommentUpdated) {
                  AppSnackBar.showSnackBar(context, text: 'Comment updated');
                } else if (state is CommentDeleted) {
                  AppSnackBar.showSnackBar(context, text: 'Comment deleted');
                } else if (state is CommentDeleteError) {
                  AppSnackBar.showSnackBar(context, text: 'Error deleting comment', isError: true);
                }
              },
              builder: (context, state) {
                if (state is CommentsLoading) {
                  return Center(child: CircularProgressIndicator(color: AppColors.detail,),);
                } else if (state is CommentsError) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_rounded, color: Colors.red.shade400,),
                        SizedBox(width: 5,),
                        Text(
                          'Error getting the comments.',
                          style: TextStyle(color: Colors.red.shade400),
                        ),
                      ],
                    ),
                  );
                } else if (state is CommentsLoaded) {
                  if (state.comments.isEmpty) {
                    return Center(
                      child: Text(
                        'No comments yet.',
                        style: TextStyle(color: Colors.black45),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) {
                      return _CommentItem(comment: state.comments[index],);
                    },
                  );
                }
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_rounded, color: Colors.red.shade400,),
                      SizedBox(width: 5,),
                      Text(
                        'Comments not found.',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _CommentField(),
        ],
      ),
    );
  }
}

class _CommentField extends StatefulWidget {

  @override
  State<_CommentField> createState() => _CommentFieldState();
  
}

class _CommentFieldState extends State<_CommentField> {
  final TextEditingController controller = TextEditingController();
  String text = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                fillColor: Colors.black12,
                filled: true,
                hintText: 'Write a comment...',
                hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              style: TextStyle(fontSize: 14),
              onChanged: (value) => text = value,
              minLines: 1,
              maxLines: 4,
            ),
          ),
          SizedBox(width: 10,),
          SizedBox(
            width: 45,
            height: 45,
            child: AppIconButton(
              icon: Icons.send_rounded,
              onPressed: () async {
                if (text.isEmpty) return;
                try {
                  await sendComment();
                } catch (e) {
                  AppSnackBar.showSnackBar(context, text: 'Error creating comment', isError: true);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> sendComment() {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<CommentsBloc>().stream.listen((state) {
      if (state is CommentCreated) {
        subscription.cancel();

        controller.clear();
        text = '';

        completer.complete();
      } else if (state is CommentCreateError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    locator<CommentsBloc>().add(CreateComment(newComment: Comment(text: text)));
    return completer.future;
  }
}

class _CommentItem extends StatefulWidget {
  final Comment comment;

  const _CommentItem({required this.comment});

  @override
  State<_CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<_CommentItem> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return AppTabItem(
      user: widget.comment.createdBy,
      date: widget.comment.createdAt,
      trailing: Row(
        children: [
          if (!isEditing)
            IconButton(
              onPressed: () => setState(() => isEditing = true),
              icon: Icon(Icons.edit_rounded, color: Colors.white,),
            ),
          IconButton(
            onPressed: () => locator<CommentsBloc>().add(DeleteComment(id: widget.comment.id ?? 0)),
            icon: Icon(Icons.delete_rounded, color: Colors.white,),
          ),
        ],
      ),
      text: widget.comment.text ?? '',
      isEditing: isEditing,
      endEdit: endEdit,
    );
  }

  Future<void> endEdit({String? newText}) async {
    if (newText == null) {
      setState(() => isEditing = false);
      return;
    }

    try {
      await updateComment(newText);
      setState(() => isEditing = false);
    } catch (e) {
      AppSnackBar.showSnackBar(context, text: 'Error updating comment', isError: true);
    }
  }

  Future<void> updateComment(String newText) async {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<CommentsBloc>().stream.listen((state) {
      if (state is CommentUpdated) {
        subscription.cancel();
        completer.complete();
      } else if (state is CommentUpdateError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    locator<CommentsBloc>().add(UpdateComment(newComment: Comment(id: widget.comment.id ?? 0, text: newText)));
    return completer.future;
  }
}