import 'package:card_flutter_example/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/multi_selection_model.dart';
import 'widgets/widgets.dart';

class MultiValuesSelectionScreen extends StatefulWidget {
  final String title;
  List<AcceptanceMultiSelectionModel> list;

  MultiValuesSelectionScreen({
    super.key,
    required this.title,
    required this.list,
  });

  @override
  State<MultiValuesSelectionScreen> createState() =>
      _MultiValuesSelectionScreenState();
}

class _MultiValuesSelectionScreenState
    extends State<MultiValuesSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            List<String> selectedList = [];

            for (var i = 0; i < widget.list.length; i++) {
              if (widget.list[i].isSelected) {
                selectedList.add(widget.list[i].title);
              }
            }
            Navigator.pop(context, selectedList);
          },
          icon: const Icon(
            CupertinoIcons.back,
          ),
        ),
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          gapH24,
          LabelTextWidget(label: widget.title),
          gapH4,
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return MultiSelectionListTileWidget(
                model: widget.list[index],
                onTap: () {
                  setState(
                    () {
                      widget.list[index].isSelected =
                          !widget.list[index].isSelected;
                    },
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return const CustomDividerWidget();
            },
            itemCount: widget.list.length,
          )
        ],
      ),
    );
  }
}
