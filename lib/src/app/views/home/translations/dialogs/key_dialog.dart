import 'package:flutter/material.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/src/app/common/app_user_info.dart';
import 'package:i18nizely/src/domain/models/key_model.dart';

class KeyDialog extends StatelessWidget {
  final TransKey transKey;
  
  const KeyDialog({super.key, required this.transKey});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 700,
        height: 450,
        child: Column(
          children: [
            AppCardTitle(title: 'Key Overview', hasClose: true,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transKey.name ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          Expanded(
                            child: transKey.description != null && transKey.description!.isNotEmpty ? SingleChildScrollView(
                              child: Text(transKey.description!),
                            ) : Center(
                              child: Text(
                                'No description.',
                                style: TextStyle(color: Colors.black45,),
                              ),
                            ),
                          ),
                          AppUserInfo(
                            image: transKey.createdBy?.image,
                            initials: transKey.createdBy?.initials ?? '',
                            name: transKey.createdBy?.name ?? 'Unknown User',
                            date: transKey.updatedAt?.toFormatStringDate(context) ?? 'Unknown Date',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.detail)
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Center(
                        child: transKey.image != null && transKey.image!.isNotEmpty ? Image.network(
                          transKey.image!,
                          fit: BoxFit.contain,
                        ) : Text(
                          'No context image.',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                    )
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