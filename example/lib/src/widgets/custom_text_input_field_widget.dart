import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInputFieldWidget extends StatelessWidget {
  final String fieldName;
  final TextEditingController controller;
  final String? hintText;

  const CustomInputFieldWidget({
    super.key,
    required this.fieldName,
    required this.controller,
    this.hintText,
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
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  fieldName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText ?? "",
                    hintStyle: const TextStyle(
                      color: CupertinoColors.placeholderText,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onChanged: (value) {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
