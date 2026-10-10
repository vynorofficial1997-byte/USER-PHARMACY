import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.index});
  final int index;

  static const _titles = ['Pharmacy', 'Hospital', 'Records', 'Insurance'];
  static const _icons = [
    Icons.medication_rounded,
    Icons.local_hospital_outlined,
    Icons.assignment_ind_outlined,
    Icons.health_and_safety_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final i = index.clamp(0, 3);
    return AppFrame(
      navIndex: i,
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(_icons[i], size: 64, color: AppColors.maroonText),
          const SizedBox(height: 12),
          Text(_titles[i].toUpperCase(), style: AppText.title(size: 24)),
          const SizedBox(height: 8),
          Text('Coming soon', style: AppText.body(size: 14, color: Colors.black54)),
        ]),
      ),
    );
  }
}
