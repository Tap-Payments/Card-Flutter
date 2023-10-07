import 'package:flutter/cupertino.dart';

class LabelTextWidget extends StatelessWidget {
  final String label;

  const LabelTextWidget({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: CupertinoColors.placeholderText,
          fontSize: 14,
        ),
      ),
    );
  }
}
