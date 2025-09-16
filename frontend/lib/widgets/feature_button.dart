import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FeatureButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? imagePath;
  final Widget navigateTo;

  const FeatureButton({
    required this.label,
    this.icon,
    this.imagePath,
    required this.navigateTo,
    super.key,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => navigateTo,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 6,
        color: Colors.green[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != null)
                Image.asset(imagePath!, width: 60, height: 60)
              else if (icon != null)
                Icon(icon, size: 60, color: Colors.green[900]),
              SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ).tr(),
            ],
          ),
        ),
      ),
    );
  }
}
