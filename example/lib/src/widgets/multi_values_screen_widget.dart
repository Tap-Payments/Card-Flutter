import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/multi_selection_model.dart';

class MultiSelectionListTileWidget extends StatelessWidget {
  final AcceptanceMultiSelectionModel model;
  final Function()? onTap;

  const MultiSelectionListTileWidget({
    super.key,
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: const RoundedRectangleBorder(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    model.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Visibility(
                      visible: model.isSelected,
                      child: const Icon(
                        Icons.check,
                        color: CupertinoColors.activeGreen,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
