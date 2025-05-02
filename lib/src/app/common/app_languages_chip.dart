import 'package:flutter/material.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';

class AppLanguagesChip extends StatefulWidget {
  final String mainLanguage;
  final Map<String, dynamic> languages;
  final void Function(List<String>) onChange;
  final String? error;

  const AppLanguagesChip({super.key, required this.mainLanguage, required this.languages, required this.onChange, this.error});

  @override
  State<AppLanguagesChip> createState() => _AppLanguagesChipState();
}

class _AppLanguagesChipState extends State<AppLanguagesChip> {
  TextEditingController controller = TextEditingController();
  List<String> selected = [];
  List<String> suggestions = [];

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
          children: [
            AppOutlinedTextField(
              label: 'Languages',
              hint: 'Search languages...',
              controller: controller,
              onChange: (value) => onSearchChange(value.toLowerCase().trim()),
              onSubmit: (_) => onSubmit(),
              textInputAction: TextInputAction.continueAction,
            ),
            SizedBox(height: 5,),
            SizedBox(
              height: 90,
              width: 400,
              child: selected.isNotEmpty ? SingleChildScrollView(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (String key in selected)
                        InputChip(
                          key: ObjectKey(key),
                          label: Text(widget.languages[key]),
                          onDeleted: () => onChipDelete(key),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(2),
                          backgroundColor: Colors.white,
                          shape: StadiumBorder(side: BorderSide(color: AppColors.detail),),
                          deleteIconColor: AppColors.detail,

                        ),
                    ],
                  ),
                ) : widget.error == null ? Center(
                  child: Text('Add languages to the project', style: TextStyle(color: Colors.black45),),
                ) : Center(
                  child: Text(widget.error!, style: TextStyle(color: Colors.red.shade400),),
                ),
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
                    key: ObjectKey(suggestions[index]),
                    title: Text(widget.languages[suggestions[index]], style: TextStyle(color: Colors.white),),
                    onTap: () => selectSuggestion(suggestions[index]),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  void onSearchChange(String value) {
    final List<String> matches = [];
    for (String key in widget.languages.keys) {
      if (key != widget.mainLanguage && widget.languages[key].toLowerCase().contains(value) && !selected.contains(key)) {
        matches.add(key);
      }
    }

    setState(() => suggestions = matches);
  }

  void onSubmit() {
    if (suggestions.isEmpty) return;
    setState(() {
      selected.add(suggestions[0]);
      suggestions.clear();
    });
    controller.clear();
    widget.onChange(selected);
  }

  void selectSuggestion(String language) {
    setState(() {
      selected.add(language);
      suggestions.clear();
    });
    widget.onChange(selected);
  }

  void onChipDelete(String language) {
    setState(() {
      selected.remove(language);
      suggestions.clear();
    });
    widget.onChange(selected);
  }
}