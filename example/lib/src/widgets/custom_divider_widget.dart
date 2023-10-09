import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDividerWidget extends StatelessWidget {
  const CustomDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 0.5,
      height: 0.5,
      color: CupertinoColors.lightBackgroundGray,
    );
  }
}
