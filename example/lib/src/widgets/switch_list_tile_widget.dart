import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchListTileWidget extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool? value)? onChange;

  const SwitchListTileWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          child: SwitchListTile(
            value: value,
            dense: false,
            activeTrackColor: CupertinoColors.activeGreen,
            contentPadding: EdgeInsets.zero,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            onChanged: onChange,
          ),
        ),
      ),
    );
  }
}
