import 'dart:io';

import 'package:card_flutter_example/src/card_view_screen.dart';
import 'package:card_flutter_example/src/models/multi_selection_model.dart';
import 'package:card_flutter_example/src/multi_values_selection_screen.dart';
import 'package:card_flutter_example/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

class ConfigSettingsScreen extends StatefulWidget {
  const ConfigSettingsScreen({super.key});

  @override
  State<ConfigSettingsScreen> createState() => _ConfigSettingsScreenState();
}

class _ConfigSettingsScreenState extends State<ConfigSettingsScreen> {
  /// Bool Selection
  /// Variable Declaration
  bool editable = true;
  bool acceptanceBadge = true;
  bool scanner = true;
  bool nfc = false;
  bool saveCard = true;
  bool autoSaveCard = true;
  bool cardHolder = true;
  bool cvv = true;
  bool loader = true;

  /// Text Form Fields
  /// Variable Declaration
  TextEditingController publicKeyController = TextEditingController(
    text: "",
  );
  TextEditingController transactionReferenceController = TextEditingController(
    text: "",
  );

  TextEditingController orderAmountController =
      TextEditingController(text: "1");
  TextEditingController orderCurrencyController = TextEditingController(
    text: "KWD",
  );
  TextEditingController orderDescriptionController = TextEditingController(
    text: "Authentication description",
  );
  TextEditingController linkToAnInvoiceController = TextEditingController();
  TextEditingController merchantIdController = TextEditingController();
  TextEditingController postURLController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();
  TextEditingController nameOnCardController = TextEditingController(
    text: "TAP PAYMENTS",
  );

  /// Scope
  /// List of scope for the user selection
  /// List & Variable Declaration

  String selectedScopeValue = "AuthenticatedToken";
  List<String> scopeList = [
    "Token",
    "AuthenticatedToken",
  ];

  /// Purpose
  /// List of purpose for the user selection
  /// List & Variable Declaration

  String selectedPurposeValue = "Charge";
  List<String> purposeList = [
    "Charge",
    "Authorize",
    "Save Token",
  ];

  /// Locale
  /// List of locale for the user selection
  /// List & Variable Declaration
  String selectedLocaleValue = "en";
  List<String> localeList = ["en", "ar"];

  /// Theme
  /// List of theme for the user selection
  /// List & Variable Declaration
  String selectedThemeValue = "light";
  List<String> themeList = ["light", "dark", "dynamic"];

  /// Edges
  /// List of edges for the user selection
  /// List & Variable Declaration
  String selectedEdgesValue = "curved";
  List<String> edgesList = ["curved", "flat", "circular"];

  /// Card Direction
  /// List of card direction for the user selection
  /// List & Variable Declaration
  String selectedCardDirectionValue = "dynamic";
  List<String> cardDirectionList = ["ltr", "rtl", "dynamic"];

  /// Color style
  /// List of color style for the user selection
  /// List & Variable Declaration
  String selectedColorStyleValue = "monochrome";

  List<String> colorStyleList = ["colored", "monochrome"];

  /// Supported Schemes
  /// List of Supported Schemes for the user selection
  /// List & Variable Declaration

  List<AcceptanceMultiSelectionModel> supportedSchemes = [
    AcceptanceMultiSelectionModel(
      title: "AMERICAN_EXPRESS",
      isSelected: true,
    ),
    AcceptanceMultiSelectionModel(
      title: "MADA",
      isSelected: true,
    ),
    AcceptanceMultiSelectionModel(
      title: "MASTERCARD",
      isSelected: true,
    ),
    AcceptanceMultiSelectionModel(
      title: "VISA",
      isSelected: true,
    ),
    AcceptanceMultiSelectionModel(
      title: "OMANNET",
      isSelected: true,
    ),
    AcceptanceMultiSelectionModel(
      title: "MEEZA",
      isSelected: false,
    ),
  ];

  List<String>? selectedSupportedSchemes = [
    "AMERICAN_EXPRESS",
    "MADA",
    "MASTERCARD",
    "VISA",
    "OMANNET"
  ];

  /// Supported Fund Source
  /// List of Supported Fund Source for the user selection
  /// List & Variable Declaration

  List<AcceptanceMultiSelectionModel> supportedFundSourceList = [
    AcceptanceMultiSelectionModel(
      title: "DEBIT",
      isSelected: true,
    ),
    AcceptanceMultiSelectionModel(
      title: "CREDIT",
      isSelected: true,
    ),
  ];

  List<String>? selectedSupportedFundSources = ["DEBIT", "CREDIT"];

  /// Supported Payment Authentications
  /// List of Supported Payment Authentications for the user selection
  /// List & Variable Declaration

  List<AcceptanceMultiSelectionModel> supportedPaymentAuthenticationsList = [
    AcceptanceMultiSelectionModel(
      title: "3DS",
      isSelected: true,
    ),
  ];

  List<String>? selectedPaymentAuthentications = ["3DS"];

  // This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
  void _showSingleValueSelectionActionSheet({
    required BuildContext context,
    required List<String> items,
    bool? scopeSelection,
    bool? purposeSelection,
    bool? localeSelection,
    bool? themeSelection,
    bool? edgesSelection,
    bool? cardDirectionSelection,
    bool? colorStyleSelection,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: CupertinoColors.activeBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: items.map(
          (e) {
            return CupertinoActionSheetAction(
              onPressed: () {
                if (scopeSelection == true) {
                  setState(() {
                    selectedScopeValue = e;
                  });
                }

                if (purposeSelection == true) {
                  setState(() {
                    selectedPurposeValue = e;
                  });
                }
                if (localeSelection == true) {
                  setState(() {
                    selectedLocaleValue = e;
                  });
                }
                if (themeSelection == true) {
                  setState(() {
                    selectedThemeValue = e;
                  });
                }
                if (edgesSelection == true) {
                  setState(() {
                    selectedEdgesValue = e;
                  });
                }
                if (cardDirectionSelection == true) {
                  setState(() {
                    selectedCardDirectionValue = e;
                  });
                }
                if (colorStyleSelection == true) {
                  setState(() {
                    selectedColorStyleValue = e;
                  });
                }
                Navigator.pop(context);
              },
              child: Text(
                e,
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontWeight:
                      e == "Cancel" ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Configurations"),
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
      ),
      body: RawScrollbar(
        thumbVisibility: true,
        child: ListView(
          children: [
            gapH24,
            const LabelTextWidget(label: "Operator"),
            gapH4,
            CustomInputFieldWidget(
              fieldName: 'Public Key',
              controller: publicKeyController,
            ),
            gapH24,
            const LabelTextWidget(label: "Scope"),
            gapH4,
            SingleValueSelectionWidget(
              keyName: 'Card Scope',
              selectedValueName: selectedScopeValue,
              onTap: () {
                _showSingleValueSelectionActionSheet(
                  context: context,
                  items: scopeList,
                  scopeSelection: true,
                );
              },
            ),
            gapH24,
            const LabelTextWidget(label: "Purpose"),
            gapH4,
            SingleValueSelectionWidget(
              keyName: 'Token Purpose',
              selectedValueName: selectedPurposeValue,
              onTap: () {
                _showSingleValueSelectionActionSheet(
                  context: context,
                  items: purposeList,
                  purposeSelection: true,
                );
              },
            ),
            gapH24,
            const LabelTextWidget(label: "MERCHANT"),
            gapH4,
            CustomInputFieldWidget(
              fieldName: 'id',
              controller: merchantIdController,
              hintText: "Enter Merchant Id",
            ),
            gapH24,
            const LabelTextWidget(label: "POST"),
            gapH4,
            CustomInputFieldWidget(
              fieldName: 'url',
              controller: postURLController,
              hintText: "Enter Post URL",
            ),
            gapH24,
            const LabelTextWidget(label: "Order"),
            CustomInputFieldWidget(
              fieldName: 'reference',
              controller: transactionReferenceController,
            ),
            const CustomDividerWidget(),
            CustomInputFieldWidget(
              fieldName: 'order amount',
              controller: orderAmountController,
            ),
            const CustomDividerWidget(),
            CustomInputFieldWidget(
              fieldName: 'order currency',
              controller: orderCurrencyController,
            ),
            const CustomDividerWidget(),
            CustomInputFieldWidget(
              fieldName: 'order description',
              controller: orderDescriptionController,
            ),
            gapH24,
            const LabelTextWidget(label: "Customer"),
            gapH4,
            CustomInputFieldWidget(
              fieldName: 'Customer id',
              controller: customerIdController,
              hintText: "Enter customer's id",
            ),
            const CustomDividerWidget(),
            CustomInputFieldWidget(
              fieldName: 'Name on Card',
              controller: nameOnCardController,
            ),
            SwitchListTileWidget(
              title: "Editable",
              onChange: (value) {
                setState(() {
                  editable = value!;
                });
              },
              value: editable,
            ),
            gapH24,
            const LabelTextWidget(label: "Features"),
            gapH4,
            SwitchListTileWidget(
              title: "acceptanceBadge",
              onChange: (value) {
                setState(() {
                  acceptanceBadge = value!;
                });
              },
              value: acceptanceBadge,
            ),
            const CustomDividerWidget(),
            SwitchListTileWidget(
              title: "cardScanner",
              onChange: (value) {
                setState(() {
                  scanner = value!;
                });
              },
              value: scanner,
            ),
            const CustomDividerWidget(),
            if (Theme.of(context).platform == TargetPlatform.android)
              SwitchListTileWidget(
                title: "cardNFC",
                onChange: (value) {
                  setState(() {
                    nfc = value!;
                  });
                },
                value: nfc,
              ),
            if (Theme.of(context).platform == TargetPlatform.android)
              const CustomDividerWidget(),
            SwitchListTileWidget(
              title: "customerCards.saveCard",
              onChange: (value) {
                setState(() {
                  saveCard = value!;
                });
              },
              value: saveCard,
            ),
            const CustomDividerWidget(),
            SwitchListTileWidget(
              title: "customerCards.autoSaveCard",
              onChange: (value) {
                setState(() {
                  autoSaveCard = value!;
                });
              },
              value: autoSaveCard,
            ),
            gapH24,
            const LabelTextWidget(label: "Acceptance"),
            gapH4,
            ListSelectionWidget(
              keyName: 'supportedSchemes',
              selectedValueName: selectedSupportedSchemes == null
                  ? ""
                  : selectedSupportedSchemes!.join(""),
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiValuesSelectionScreen(
                      title: "supportedSchemes",
                      list: supportedSchemes,
                    ),
                  ),
                );

                if (result != null) {
                  selectedSupportedSchemes = result;
                  setState(() {});
                } else {
                  selectedSupportedSchemes = null;
                  setState(() {});
                }
              },
            ),
            const CustomDividerWidget(),
            ListSelectionWidget(
              keyName: 'supportedFundSource',
              selectedValueName: selectedSupportedFundSources == null
                  ? ""
                  : selectedSupportedFundSources!.join(""),
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiValuesSelectionScreen(
                      title: "supportedFundSource",
                      list: supportedFundSourceList,
                    ),
                  ),
                );

                if (result != null) {
                  selectedSupportedFundSources = result;
                  setState(() {});
                } else {
                  selectedSupportedFundSources = null;
                  setState(() {});
                }
              },
            ),
            const CustomDividerWidget(),
            ListSelectionWidget(
              keyName: 'supportedPaymentAuthentications',
              selectedValueName: selectedPaymentAuthentications == null
                  ? ""
                  : selectedPaymentAuthentications!.join(""),
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiValuesSelectionScreen(
                      title: "supportedPaymentAuthentications",
                      list: supportedPaymentAuthenticationsList,
                    ),
                  ),
                );

                if (result != null) {
                  selectedPaymentAuthentications = result;
                  setState(() {});
                } else {
                  selectedPaymentAuthentications = null;
                  setState(() {});
                }
              },
            ),
            gapH24,
            const LabelTextWidget(label: "FieldVisibility.Card*"),
            gapH4,
            SwitchListTileWidget(
              title: "Card holder",
              value: cardHolder,
              onChange: (value) {
                setState(() {
                  cardHolder = value!;
                });
              },
            ),
            const CustomDividerWidget(),
            SwitchListTileWidget(
              title: "cvv",
              value: cvv,
              onChange: (value) {
                setState(() {
                  cvv = value!;
                });
              },
            ),
            gapH24,
            const LabelTextWidget(label: "Interface"),
            gapH4,
            const CustomDividerWidget(),
            SingleValueSelectionWidget(
              keyName: 'locale',
              selectedValueName: selectedLocaleValue,
              onTap: () {
                _showSingleValueSelectionActionSheet(
                  context: context,
                  items: localeList,
                  localeSelection: true,
                );
              },
            ),
            const CustomDividerWidget(),
            SingleValueSelectionWidget(
              keyName: 'theme',
              selectedValueName: selectedThemeValue,
              onTap: () {
                _showSingleValueSelectionActionSheet(
                  context: context,
                  items: themeList,
                  themeSelection: true,
                );
              },
            ),
            const CustomDividerWidget(),
            SingleValueSelectionWidget(
              keyName: 'edges',
              selectedValueName: selectedEdgesValue,
              onTap: () {
                _showSingleValueSelectionActionSheet(
                  context: context,
                  items: edgesList,
                  edgesSelection: true,
                );
              },
            ),
            const CustomDividerWidget(),
            SingleValueSelectionWidget(
              keyName: 'cardDirection',
              selectedValueName: selectedCardDirectionValue,
              onTap: () {
                _showSingleValueSelectionActionSheet(
                  context: context,
                  items: cardDirectionList,
                  cardDirectionSelection: true,
                );
              },
            ),
            const CustomDividerWidget(),
            SwitchListTileWidget(
              title: "loader",
              value: loader,
              onChange: (value) {
                setState(() {
                  loader = value!;
                });
              },
            ),
            const CustomDividerWidget(),
            SingleValueSelectionWidget(
              keyName: 'colorStyle',
              selectedValueName: selectedColorStyleValue,
              onTap: () {
                _showSingleValueSelectionActionSheet(
                  context: context,
                  items: colorStyleList,
                  colorStyleSelection: true,
                );
              },
            ),
            gapH40,
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CardViewScreen(),
                    ),
                  );
                },
                child: const Text("Next"),
              ),
            ),
            gapH40,
          ],
        ),
      ),
    );
  }
}
