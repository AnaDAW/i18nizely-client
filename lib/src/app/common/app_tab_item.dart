import 'package:flutter/material.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

class AppTabItem extends StatelessWidget {
  final User? user;
  final DateTime? date;
  final Widget trailing;
  final String text;
  final bool isEditing;
  final Future<void> Function({String? newText})? endEdit;

  const AppTabItem({super.key, required this.user, required this.date, required this.trailing, required this.text, this.isEditing = false, this.endEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
              gradient: AppColors.gradient,
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(5),
                  child: AppUserIcon(
                    image: user?.image,
                    userName: user?.initials ?? '',
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user?.name ?? 'Unknown User',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      date?.toFormatStringDate(context) ?? 'Unknown Date',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ]
                ),
                Spacer(),
                trailing,
                SizedBox(width: 10,)
              ],
            ),
          ),
          isEditing ? _EditingField(
            text: text,
            endEdit: endEdit!,
          ) : Padding(
            padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
            child: Text(text),
          ),
          Divider(color: AppColors.detail, indent: 5,),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}

class _EditingField extends StatefulWidget {
  final String text;
  final Future<void> Function({String? newText}) endEdit;

  const _EditingField({required this.text, required this.endEdit});

  @override
  State<_EditingField> createState() => _EditingFieldState();
}

class _EditingFieldState extends State<_EditingField> {
  String text = '';
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextFormField(
                initialValue: widget.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1),
                  ),
                  hintText: 'Type here the comment...',
                  hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                ),
                style: TextStyle(fontSize: 14),
                minLines: 2,
                maxLines: 4,
                onChanged: checkTextChanged,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: hasChanged ? () => widget.endEdit(newText: text) : null,
                icon: Icon(
                  Icons.check_rounded,
                  color: hasChanged ? Colors.green.shade400 : Colors.green.shade100
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.endEdit();
                  hasChanged = false;
                  text = '';
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.red.shade400
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void checkTextChanged(String newText) {
    if (hasChanged && (newText.isEmpty || newText == widget.text)) {
      setState(() => hasChanged = false,);
    }
    
    if (!hasChanged && newText.isNotEmpty && newText != widget.text) {
      setState(() => hasChanged = true,);
    }
    text = newText;
  }
}