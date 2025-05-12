import 'package:flutter/material.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/src/app/common/app_user_info.dart';
import 'package:i18nizely/src/domain/models/translation_model.dart';

class TranslationDialog extends StatelessWidget {
  final Translation translation;
  final String language;
  
  const TranslationDialog({super.key, required this.translation, required this.language});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 450,
        height: 400,
        child: Column(
          children: [
            AppCardTitle(title: 'Translation Overview', hasClose: true,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                      child: Text(translation.text ?? ''),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Translated by:',
                              style: TextStyle(color: Colors.black45, fontSize: 12),
                            ),
                            SizedBox(height: 5,),
                            AppUserInfo(
                              image: translation.createdBy?.image,
                              initials: translation.createdBy?.initials ?? '',
                              name: translation.createdBy?.name ?? 'Unknown User',
                              date: translation.updatedAt?.toFormatStringDate(context) ?? 'Unknown Date',
                            ),
                          ],
                        ),
                        if (translation.isReviewed == true)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Reviewed by:',
                                style: TextStyle(color: Colors.black45, fontSize: 12),
                              ),
                              SizedBox(height: 5,),
                              AppUserInfo(
                                image: translation.reviewedBy?.image,
                                initials: translation.reviewedBy?.initials ?? '',
                                name: translation.reviewedBy?.name ?? 'Unknown User',
                                date: translation.reviewedAt?.toFormatStringDate(context) ?? 'Unknown Date',
                                invert: true,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}