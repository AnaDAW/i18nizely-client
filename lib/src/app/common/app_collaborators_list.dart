import 'dart:async';

import 'package:flutter/material.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_snackbar.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_state.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/project_model.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';
import 'package:i18nizely/src/domain/services/user_api.dart';

class AppCollaboratorsList extends StatefulWidget {
  final User createdBy;
  final List<Collaborator> collaborators;

  const AppCollaboratorsList({super.key, required this.createdBy, required this.collaborators});

  @override
  State<StatefulWidget> createState() => _AppCollaboratorsListState();
}

class _AppCollaboratorsListState extends State<AppCollaboratorsList> {
  TextEditingController controller = TextEditingController();
  List<User> suggestions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppOutlinedTextField(
              label: 'Collaborators',
              hint: 'Search users...',
              controller: controller,
              onChange: (value) async => await onSearchChange(value.trim()),
              onSubmit: (_) async => await selectSuggestion(suggestions[0]),
              textInputAction: TextInputAction.continueAction,
            ),
            SizedBox(height: 40,),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'User Name',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Admin',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Developer',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Translator',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Reviewer',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 40,),
                ],
              ),
            ),
            if (widget.collaborators.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'No collaborators yet.',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
              ),
            SizedBox(height: 5,),
            for (int i = 0; i < widget.collaborators.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 15,),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: AppUserIcon(
                          image: widget.collaborators[i].user.image,
                          userName: widget.collaborators[i].user.initials,
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(widget.collaborators[i].user.name, overflow: TextOverflow.ellipsis,),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Checkbox(
                          value: widget.collaborators[i].roles.contains(CollabRole.admin),
                          onChanged: (value) async {
                            if (value == null) return;

                            late List<CollabRole> roles;
                            if (value) {
                              roles = [CollabRole.admin];
                            } else {
                              roles = [CollabRole.developer, CollabRole.translator, CollabRole.reviewer];
                            }

                            try {
                              final Collaborator newCollaborator = Collaborator(id: widget.collaborators[i].id ?? 0, user: widget.collaborators[i].user, roles: roles);
                              await updateCollaborator(newCollaborator);
                            } catch (e) {
                              AppSnackBar.showSnackBar(context, text: 'Error updating collaborator', isError: true);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Checkbox(
                          value: widget.collaborators[i].roles.contains(CollabRole.developer),
                          onChanged: (value) async {
                            if (value == null) return;
                            await changeCollaboratorRole(value, i, CollabRole.developer);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: Checkbox(
                          value: widget.collaborators[i].roles.contains(CollabRole.translator),
                          onChanged: (value) async {
                            if (value == null) return;
                            await changeCollaboratorRole(value, i, CollabRole.translator);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Checkbox(
                          value: widget.collaborators[i].roles.contains(CollabRole.reviewer),
                          onChanged: (value) async {
                            if (value == null) return;
                            await changeCollaboratorRole(value, i, CollabRole.reviewer);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: IconButton(
                          onPressed: () async {
                            try {
                              await removeCollaborator(widget.collaborators[i].id ?? 0);
                            } catch (e) {
                              AppSnackBar.showSnackBar(context, text: 'Error removing collaborator', isError: true);
                            }
                          },
                          icon: Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                  Divider(color: Colors.black45, indent: 5, endIndent: 5,)
                ],
              ),
          ],
        ),
        if (suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 78),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 95,
              ),
              decoration: BoxDecoration(
                color: AppColors.detail,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    key: ValueKey(suggestions[index].id),
                    title: Text(suggestions[index].name, style: TextStyle(color: Colors.white),),
                    onTap: () async => await selectSuggestion(suggestions[index]),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Future<void> onSearchChange(String value) async {
    var res = await locator<UserApi>().getUsers(name: value);
    res.fold((left) {

    }, (right) {
      final List<User> matches = [];

      for (User user in right) {
        if (widget.createdBy == user) continue;
        final Collaborator? collaborator = widget.collaborators.where((collab) => collab.user.id == user.id).firstOrNull;
        if (collaborator == null) matches.add(user);
      }

      setState(() => suggestions = matches);
    });
  }

  Future<void> selectSuggestion(User user) async {
    try {
      final Collaborator newCollaborator = Collaborator(user: user, roles: [CollabRole.admin]);
      await addCollaborator(newCollaborator);
      setState(() => suggestions.clear());
    } catch (e) {
      AppSnackBar.showSnackBar(context, text: 'Error adding collaborator', isError: true);
    }
  }

  Future<void> changeCollaboratorRole(bool value, int index, CollabRole collabRole) async {
    List<CollabRole> roles = widget.collaborators[index].roles;
    if (value) {
      roles.remove(CollabRole.admin);
      if (!roles.contains(collabRole)) roles.add(collabRole);
    } else {
      roles.remove(collabRole);
      if (roles.isEmpty) roles.add(CollabRole.admin);
    }

    try {
      final Collaborator newCollaborator = Collaborator(id: widget.collaborators[index].id ?? 0, user: widget.collaborators[index].user, roles: roles);
      await updateCollaborator(newCollaborator);
    } catch (e) {
      AppSnackBar.showSnackBar(context, text: 'Error updating collaborator', isError: true);
    }
  }

  Future<void> addCollaborator(Collaborator newCollaborator) async {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<ProjectBloc>().stream.listen((state) {
      if (state is CollaboratorAdded) {
        subscription.cancel();
        controller.clear();
        completer.complete();
      } else if (state is CollaboratorAddError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    locator<ProjectBloc>().add(AddCollaborator(newCollaborator: newCollaborator));
    return completer.future;
  }

  Future<void> updateCollaborator(Collaborator newCollaborator) async {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<ProjectBloc>().stream.listen((state) {
      if (state is CollaboratorUpdated) {
        subscription.cancel();
        completer.complete();
      } else if (state is CollaboratorUpdateError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    locator<ProjectBloc>().add(UpdateCollaborator(id: newCollaborator.id ?? 0, roles: newCollaborator.roles));
    return completer.future;
  }

  Future<void> removeCollaborator(int id) async {
    late StreamSubscription subscription;
    final completer = Completer<void>();

    subscription = locator<ProjectBloc>().stream.listen((state) {
      if (state is CollaboratorRemoved) {
        subscription.cancel();
        completer.complete();
      } else if (state is CollaboratorRemoveError) {
        subscription.cancel();
        completer.completeError(state.data);
      }
    });

    locator<ProjectBloc>().add(RemoveCollaborator(id: id));
    return completer.future;
  }
}