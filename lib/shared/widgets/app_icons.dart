import 'package:flutter/material.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';

class AppUserIcon extends StatelessWidget {
  final String? image;
  final String userName;

  const AppUserIcon({this.image, this.userName = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
        border: Border.all(width: 1, color: AppColors.detail,),
      ),
      child: Center(
        child: image != null && image!.isNotEmpty ? Image.network(image!) :
        FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(userName, style: TextStyle(fontSize: 100),),
          ),
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool primary;

  const AppIconButton({super.key, required this.icon, required this.onPressed, this.primary = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: primary ? Colors.white : Colors.black45,)
      ),
    );
  }
}

class AppSecondaryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const AppSecondaryIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 225, 225),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black45,)
      ),
    );
  }
}

class AppDrawerIcon extends StatelessWidget {
  final bool isExpanded;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;
  final bool enabled;

  const AppDrawerIcon({super.key, required this.isExpanded, required this.icon, required this.label, this.isSelected = false, required this.onPressed, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 60,
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        icon: Row(
          children: [
            Icon(icon, color: enabled ? Colors.white : Colors.black45),
            if (isExpanded)
              Row(
                children: [
                  SizedBox(width: 15,),
                  Text(
                    label,
                    style: TextStyle(
                        color: isSelected ? Colors.black : enabled ? Colors.white : Colors.black45,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

}