



# Card-Flutter

Integrating Flutter Card SDK in your application

# Introduction[](https://developers.tap.company/docs/card-sdk-flutter#introduction)

Before diving into the development process, it's essential to establish the prerequisites and criteria necessary for a successful build. In this step, we'll outline the specific iOS/Android requirements, including the minimum SDK version and other important details you need to consider. Let's ensure your project is set up for success from the very beginning.

# Sample Demo

![enter image description here](https://github.com/Tap-Payments/Card-iOS/raw/main/ezgif.com-video-to-gif.gif?raw=true)



# Step 1: Requirements[](https://developers.tap.company/docs/card-sdk-flutter#step-1-requirements)

- We support from iOS 13.0+
- Dart 3.0.0+
- Java version 11
- A minimum  [Android SDK/API level](https://developer.android.com/guide/topics/manifest/uses-sdk-element#ApiLevels) of 24
- In order to be able to use card scanner functionality, please make sure you added the correct permission key-value in the iOS project info.plist.

``` <key>NSCameraUsageDescription</key> <string>Card SDK needs it for scanner functionality</string> ```

- in order to accept online payments on your application, you will need to add at least the Internet permission in the manifest file.

``` <uses-permission android:name="android.permission.INTERNET" /> //get internet access to complete online payments ```

# Step 2: Get Your Public Keys[](https://developers.tap.company/docs/card-sdk-flutter#step-2-get-your-public-keys)

While you can certainly use the sandbox keys available within our sample app which you can get by following the  [installation](https://developers.tap.company/docs/android-card-sdk#step-3-installation-using-gradle) process, however, we highly recommend visiting our  [onboarding](https://register.tap.company/ae/en/sell) page, there you'll have the opportunity to register your package name and acquire your essential Tap Key for activating Card-Flutter integration. If you will support both iOS and Android, you will need to have two different keys for each app.

# Step 3: Installation[](https://developers.tap.company/docs/card-sdk-flutter#step-3-installation)
In the  `pubspec.yaml` of your flutter project, add the following dependency:

dependencies:

```card_flutter: 1.0.8```

In your library add the following import:

`import 'package:card_flutter/card_flutter.dart';`



# Step 4: Integrating Card-Flutter[](https://developers.tap.company/docs/card-sdk-flutter#step-4--integrating-card-flutter)

This integration offers two distinct options: a  [simple integration](https://developers.tap.company/docs/android-card-sdk#simple-integration) designed for rapid development and streamlined merchant requirements, and an  [advanced integration](https://developers.tap.company/docs/android-card-sdk#advanced-integration) that adds extra features for a more dynamic payment integration experience.

## Integration Flow[](https://developers.tap.company/docs/card-sdk-flutter#integration-flow)

Noting that in Flutter, you will use our card form like any other widget. While creating, the widget you will also need to pass the parameters & listen to the callbacks based on your needs.

1. You will have to create a variable of type TapCardViewWidget
2. While intialising the widget:
    - Pass the parameters to the widget.
    - Implement the provided interfaces/callbacks
3. Our card widget is a stateful one, depends on stateful variable to generate the token. More to follow.
4. Start tokenizing a card on demand.

### Using Code to create the TapCardViewWidget[](https://developers.tap.company/docs/card-sdk-ios#using-code-to-create-the-tapcardviewwidget)

-   **Creating the TapCardViewWidget from code**
1. Head to your controller where you want to display the `TapCardViewWidget` as a widget.
2. Import `Card-Flutter` as follows `import 'package:card_flutter/models/models.dart`.
3. In the coming code sample, we will show how to embed the card form within your widget tree.
```dart
 TapCardViewWidget( sdkConfiguration: const {}, generateToken: false // More on this later),   
```
## Simple Integration[](https://developers.tap.company/docs/card-sdk-flutter#simple-integration)

Here, you'll discover a comprehensive table featuring the parameters applicable to the simple integration. Additionally, you'll explore the various methods for integrating the SDK. Furthermore, you'll gain insights into card tokenization after the initial payment and learn how to receive the callback notifications.

### Parameters[](https://developers.tap.company/docs/card-sdk-flutter#parameters)
Each parameter is linked to the  [reference](https://developers.tap.company/docs/card-sdk-flutter#reference) section, which provides a more in depth explanation of it.

|Parameter|Description | Required | Type| Sample      
|--|--|--| --|--| | operator| Key obtained after registering your package name, also known as Public key. | True  | Map| `{"operator": {"publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"}` | | scope| Defines the intention of using Card-Flutter. | True  | String| ` String scope = "Token"`| | purpose| Defines the intention of using the generated Token. | True  | String| `String purpose = "Charge"` | | order| Order details linked to the token. | True  | `Map`| `order = {"id":"", "amount":1, "currency":"SAR", "description": "Authentication description", "reference":""}` | | customer|Customer details for tokenization process. | True  | `Map`| ` customer = {"id":"", "name":[{"lang":"en","first":"TAP","middle":"","last":"PAYMENTS"}], "nameOnCard":"TAP PAYMENTS", "editble":true, "contact":{"email":"tap@tap.company", "phone":{"countryCode":"+965","number":"88888888"}}}` |

### Configuring the Card-Flutter SDK[](https://developers.tap.company/docs/card-sdk-flutter#configuring-the-card-flutter-sdk)

While creating the widget as previously mentioned, it is time to pass the parameters needed for the SDK to work as expected and serve your need correctly.

1.  **Creating the parameters**        
    To allow flexibility and to ease the integration, your application will only has to pass the parameters as a  `Dictionary[String:Any]` .        
    First, let us create the required parameters:

```dart 
/// The minimum needed configuration Map<String,dynamic> parameters  = {  
 "customer":{ "name":[ { "first":"TAP", "middle":"", "lang":"en", "last":"PAYMENTS" } ], "contact":{ "email":"tap@tap.company", "phone":{ "countryCode":"+965", "number":"88888888" } } }, "purpose":"Charge", "operator":{ "publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7" }, "scope":"Token", "order":{ "description":"", "currency":"SAR", "amount":1.0 }}  
    
```
2. Pass these parameters to the TapCardViewWidget widget
```dart
 // We provide the card view the needed parameters. TapCardViewWidget(sdkConfiguration: parameters, generateToken: generateToken,) // This generate token is a stateful variable, if set to true token will be generated   
``` 
**Full code snippet for creating the parameters + passing it TapCardViewWidget variable + Listening to callbacks**
```dart  
   import 'package:card_flutter/card_flutter.dart'; 
   import 'package:flutter/cupertino.dart';    
   import 'package:flutter/material.dart';    
   import 'config_settings_screen.dart';    
   class CardViewScreen extends StatefulWidget {    
   final Map<String, dynamic> dictionaryMap;    
    
  const CardViewScreen({    
  super.key,    
    required this.dictionaryMap,    
  });    
    
  @override    
State<CardViewScreen> createState() => _CardViewScreenState(); }    
 class _CardViewScreenState extends State<CardViewScreen> {    
  dynamic mCardSDKResponse;    
    
  bool generateToken = false;    
    
  bool showTapTokenButton = false;    
   
    
  @override    
  Widget build(BuildContext context) {    
  return Scaffold(    
       appBar: AppBar(    
       title: const Text('Plugin example app'),    
       leading: IconButton(    
       onPressed: () {    
           Navigator.pushAndRemoveUntil(    
                  context,    
                MaterialPageRoute(    
                  builder: (context) => const ConfigSettingsScreen(),    
                ),    
                (route) => false);    
          },    
          icon: const Icon(    
             CupertinoIcons.back,    
          ),    
        ),    
      ),    
      body: Column(    
        mainAxisSize: MainAxisSize.min,    
        children: [    
          TapCardViewWidget(    
            sdkConfiguration: widget.dictionaryMap,    
            onReady: () {    
              setState(() {    
               showTapTokenButton = true;    
              });    
            },    
            onFocus: () {    
              setState(() {    
                generateToken = false;    
              });    
            },    
            onSuccess: (String? success) {    
               setState(() {    
                mCardSDKResponse = success.toString();    
                generateToken = false;    
              });    
            },    
            onValidInput: (String? validInput) {    
               setState(() {    
                mCardSDKResponse = validInput.toString();    
                generateToken = false;    
              });    
            },    
            onHeightChange: (String? heightChange) {    
               setState(() {    
                mCardSDKResponse = heightChange.toString();    
              });    
            },    
            onBinIdentification: (String? bindIdentification) {    
              setState(() {    
                mCardSDKResponse = bindIdentification.toString();    
              });    
            },    
            onChangeSaveCard: (String? saveCard) {    
             setState(() {    
                  mCardSDKResponse = saveCard.toString();    
              });    
            },    
            onError: (String? error) {    
             setState(() {    
                mCardSDKResponse = error.toString();    
                generateToken = false;    
              });    
            },    
            generateToken: generateToken,    
            cardNumber: "512345000000****",    
            cardExpiry: "01/39",    
          ),    
          const SizedBox(height: 10),    
          Visibility(    
            visible: showTapTokenButton,    
            child: Padding(    
            padding: const EdgeInsets.symmetric(horizontal: 12),    
              child: FilledButton(    
                  onPressed: () {    
                     setState(() {    
                      generateToken = true;    
                  });    
                },    
                style: FilledButton.styleFrom(    
                fixedSize: Size(    
                      MediaQuery.sizeOf(context).width * 0.96,    
                    50,    
                  ),    
                  shape: RoundedRectangleBorder(    
                      borderRadius: BorderRadius.circular(8),    
                  ),    
                ),    
                onHover: (bool? value) {},    
                child: const Text(    
                    "Get Tap Token",    
                ),    
              ),    
            ),    
          ),    
          const SizedBox(height: 10),    
          Expanded(    
            child: Padding(    
            padding: const EdgeInsets.all(16.0),    
            child: SingleChildScrollView(    
                    child: SelectableText(    
                             mCardSDKResponse == null    
                             ? ""    
                             : "SDK RESPONSE : $mCardSDKResponse",    
                  textAlign: TextAlign.center,    
                  style: const TextStyle(    
                  color: Colors.black,    
                  fontSize: 12,    
                  ),    
                ),    
              ),    
            ),    
          ),    
        ],    
      ),    
    );    
} }  
```   
### Tokenise the card[](https://developers.tap.company/docs/card-sdk-flutter#tokenise-the-card)

> 📘
>
> A token is like a secret code that stands in for sensitive info, like credit card data. Instead of keeping the actual card info, we use this code. Tokens are hard for anyone to understand if they try to peek, making it a safer way to handle sensitive stuff.

Following the above code samples, once the TapCardViewWidget now has a valid input, you will be able to start the tokenization process by changing the stateful variable `generateToken` to true as we declared above, which you can find by following  [Step 5 - Tokenize the card](https://developers.tap.company/docs/flutter-card-sdk#step-5-tokenize-the-card).

## Advanced Integration

[](https://developers.tap.company/docs/card-sdk-flutter#advanced-integration)

The advanced configuration for the Card-Flutter integration not only has all the features available in the simple integration but also introduces new capabilities, providing merchants with maximum flexibility. You can find a code below, where you'll discover comprehensive guidance on implementing the advanced flow as well as a complete description of each parameter.

### Parameters[](https://developers.tap.company/docs/card-sdk-flutter#parameters-1)
Each parameter is linked to the  [reference](https://developers.tap.company/docs/flutter-card-sdk#reference) section, which provides a more in depth explanation of it.      
|Configuration|Description | Required | Type| Sample      
|--|--|--| --|--|      
| operator| Key obtained after registering your bundle id. | True  | Map| `{"operator": {"publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"}` | scope| Defines the intention of using `Card-Flutter`. | True  | String| `String scope = "Token"`|      
| purpose|Defines the intention of using the generated Token. | True  | String| `String purpose = "Charge"` |      
| order| Order details linked to the token. | True  | `Map`| `"order" = : {"description": "Authentication description","currency": "KWD","amount": 1,"id": "","reference": "","metadata": {}}` |          
| merchant| Merchant id obtained after registering your bundle id. | True  | `Map`| `merchant = {"id":""}` |      
| customer|Customer details for tokenization process. | True  | `Map`| ` customer = {"id":"", "name":[{"lang":"en","first":"TAP","middle":"","last":"PAYMENTS"}], "nameOnCard":"TAP PAYMENTS", "editble":true, "contact":{"email":"tap@tap.company", "phone":{"countryCode":"+965","number":"88888888"}}}` |      
| features| Extra features for customization (optional). | False  | `Map`| `features = {"alternativeCardInputs":{"cardScanner":true, "cardNFC": true}, "acceptanceBadge":true, "customerCards":{"saveCard":false, "autoSaveCard":false}}`|      
| acceptance| Acceptance details for the transaction (optional). | False  | `Map`| `acceptance = {"supportedSchemes":["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"], "supportedFundSource":["CREDIT","DEBIT"], "supportedPaymentAuthentications":["3DS"]}`|      
| fieldVisibility| Visibility of optional fields in the card form (optional). | False  | `Map`| `fieldVisibility = {"card":{"cardHolder":true, "cvv": true}}` |      
| interface| Look and feel related configurations (optional). | False  | `Map`| `interface = {"locale": "en", "theme": "light", "edges": "curved", "cardDirection": "dynamic", "colorStyle": "colored", "loader": true}` |      
| post| Webhook for server-to-server updates (optional). | False  | `Mao=o`| `post = {"url":""}` |

### Initialisation of the input[](https://developers.tap.company/docs/card-sdk-ios#initialisation-of-the-input)

You can use a Map<String,dynamic> to send data to our SDK. The benefit is that you can generate this data from one of your APIs. If we make updates to the configurations, you can update your API, avoiding the need to update your app on the  App/Play Store.

```dart {    
  "features": {    
  "customerCards": {    
      "saveCard": true,    
      "autoSaveCard": true    
       },    
  "alternativeCardInputs": {    
      "cardScanner": true,    
      "cardNFC": false,    
      },    
  "acceptanceBadge": true,    
  },    
  "post": const {"url": ""},    
  "customer": {    
  "id": "",    
      "name": const [    
    {    
        "first": "TAP",    
        "middle": "",    
        "lang": "en",    
        "last": "PAYMENTS"    
    }    
  ],    
    "editable": true,    
    "contact": const {    
     "email": "tap@tap.company",    
        "phone": {    
           "countryCode": "+965",    
           "number": "88888888"    
     }    
  },    
    "nameOnCard": "",    
  },    
  "fieldVisibility": {    
   "card": {    
      "cardHolder": true,    
      "cvv": true,    
    }    
  },    
  "merchant": {"id": ""},    
  "interface": {    
    "colorStyle": "colored",    
    "theme": "light",    
    "locale": "en",    
    "edges": "curved",    
    "cardDirection": "dynamic",    
    "loader": true    
  },    
  "purpose": "Charge",    
  "operator": {    
  "publicKey": "",    
  },    
  "scope": "Token",    
  "order": {    
  "description": "",    
    "currency": "SAR",    
    "amount": 1.0,    
    "id": "",    
    "reference": "",    
    "metadata": const {"a": "abc"}    
  },    
  "acceptance": {    
    "supportedPaymentAuthentications":    
                ["3DS"],    
    "supportedFundSource": ["CREDIT","DEBIT"],    
    "supportedSchemes": [ "AMERICAN_EXPRESS", "MADA", "MASTERCARD", "VISA", "OMANNET"],    
  },    
 },  
 },
 }   
```   
### Receiving Callback Notifications (Advanced Version)[](https://developers.tap.company/docs/card-sdk-ios#receiving-callback-notifications-advanced-version)

The below will allow the integrators to get notified from events fired from the TapCardViewWidget.

```Dart
 TapCardViewWidget(    
  sdkConfiguration: widget.dictionaryMap,    
  onReady: () {    
  },    
  onFocus: () {    
  },    
  onSuccess: (String? success) {    
  },    
  onValidInput: (String? validInput) {     
  },    
  onHeightChange: (String? heightChange) {    
  },    
  onBinIdentification: (String? bindIdentification) {    
  },    
  onChangeSaveCard: (String? saveCard) {   
   },
  onError: (String? error) {    
  },    
  generateToken: true,    
  cardNumber: "51234500********",    
  cardExpiry: "01/39", ),   
```   
# Step 5: Tokenize the Card[](https://developers.tap.company/docs/card-sdk-flutter#step-5-tokenize-the-card)

The Card-Flutter SDK provides a stateful variable, that allows you to instruct it to start the tokenization process on demand or whenever you see convenient, in your logic flow. As a guidance we would only recommend calling this interface after getting  **onValidInput** with data `true` callback as described above and shown in the code block below.

> 📘
>
> Tokenize the Card
>
> ### >
> What is a Token?
>
> [](https://developers.tap.company/docs/card-sdk-android#what-is-a-token)
>
> A token is like a secret code that stands in for sensitive info, like credit card data. Instead of keeping the actual card info, we use this code. Tokens are hard for anyone to understand if they try to peek, making it a safer way to handle sensitive stuff.
>
> ### >
> What is Tokenization of a Card?
>
> [](https://developers.tap.company/docs/card-sdk-android#what-is-a-token)
>
> Card tokenization is like changing your credit card into a secret code. You can use this code safely without showing your actual card info. It's a common practice in payments to keep things secure and prevent your card details from being seen by others.
>
> ### >
> Why Do I Need to Tokenize a Card?
>
> [](https://developers.tap.company/docs/card-sdk-android#what-is-tokenization-of-a-card)
>
> There are several reasons to tokenize a card:
>
> -   **Security** > Tokenization helps protect sensitive card data, reducing the risk of data breaches or unauthorized access.
> -   **Compliance** > Many regulations and industry standards, like PCI DSS, require the use of tokenization to safeguard cardholder data.
> -   **Recurring Payments** > Tokens are useful for recurring payments, as they allow you to charge a customer's card without storing their actual card details.
> -   **Convenience** > Tokens simplify payment processing, as you only need to deal with tokens instead of card numbers.
1. Declare a boolean variable in your stateful widget
2. This variable will be passed to the TapCardViewWidget while initialisation as below.
3. Whenever you need, change it to true to trigger the tokenization status in the TapcardViewWidget.

> 👍
>
> Also, once you correctly trigger the interface, you should expect to hear back from the SDK in one of two callbacks, onSuccess or onError.


# Parameters Reference[](https://developers.tap.company/docs/card-sdk-flutter#parameters-reference)

Below you will find more details about each parameter shared in the above tables that will help you easily integrate Card-Flutter SDK.

## operator[](https://developers.tap.company/docs/card-sdk-flutter#operator)

1. Definition: It links the payment gateway to your merchant account with Tap, in order to know your business name, logo, etc...
2. Type: string (_required_)
3. Fields:
    -   **publicKey**        
        _Definition_: This is a unique public key that you will receive after creating an account with Tap which is considered a reference to identify you as a merchant. You will receive 2 public keys, one for sandbox/testing and another one for production.
4. Example:

```dart  
"operator": {"publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"}  
``` 
## scope [](https://developers.tap.company/docs/card-sdk-flutter#scope)

1. Definition: This is used in order to identify the type of token you want to generate. A token is created in order to save the card details after submitting the form in a more secure way.
2. Type: String (_required_)
3. Possible Values:
    -   **Token**        
        _Definition:_ Created before the payment in complete, in order to save the card and do a charge later    
        Example: `String scope = "Token"`
-   **AuthenticatedToken**        
    _Definition:_ This is a token created and authenticated by the customer. Which means that the customer entered the card information and also passed the Authentication step (3DS) and got the token after.        
    _Example:_ `String scope = "AuthenticatedToken"`

## purpose[](https://developers.tap.company/docs/card-sdk-flutter#purpose)

1. Definition: This will identify the reason of choosing the type of token generated in the scope field, like if it will be used for a single transaction, recurring, saving the token, etc...        
   Note: Only choose the option that suits your needs best.
2. Type: String (_required_)
3. Possible Values:
-   **Charge**:        
    _Definition:_ Perform a charge transaction. Capturing an amount from the customer       
    _Example:_  `String purpose = "Charge"`
-   **Authorize**:        
    _Definition:_ Perform a hold on the amount.  
    _Example:_ `String purpose = "Authorize"`
-   **Save Token**:        
    _Definition:_ Save the card to use it afterwards in MITs.       
    _Example:_`String purpose = "Save Token"`

## order [](https://developers.tap.company/docs/card-sdk-flutter#order)

1. Definition: This defined the details of the order that you are trying to purchase, in which you need to specify some details like the id, amount, currency ...
2. Type: Map<String,dynamic>, (_required_)
3. Fields:
    -   **id**        
        _Definition:_ Pass the order ID created for the order you are trying to purchase, which will be available in your database.        
        Note: This field can be empty
    -   **currency**        
        _Definition:_ The currency which is linked to the order being paid.
    -   **amount**        
        _Definition:_ The order amount to be paid by the customer.        
        Note: Minimum amount to be added is 0.1.
    -   **description**        
        _Definition:_ Order details, which defines what the customer is paying for or the description of the service you are providing.
    -   **reference**        
        _Definition:_ This will be the order reference present in your database in which the paying is being done for.
4.  _Example:_
 ```dart   
 "order": {    
  "description": "",    
    "currency": "SAR",    
    "amount": 1.0,    
    "id": "",    
    "reference": "",    
    "metadata": const {"a": "abc"}    
}   
 ``` 
## merchant

[](https://developers.tap.company/docs/card-sdk-flutter#merchant)

1. Definition: It is the Merchant id that you get from our onboarding team. This will be used as reference for your account in Tap.
2. Type: Map<String,dynamic> (_required_)
3. Fields:
    -   **id**        
        _Definition:_ Generated once your account with Tap is created, which is unique for every merchant.
4. _Example:_  ```dart    merchant = {"id":""} ```

## customer [](https://developers.tap.company/docs/card-sdk-flutter#customer)

1. Definition: Here, you will collect the information of the customer that is paying using the token generate in the SDK.

2. Type: Map<String,dynamic> (_required_)

3. Fields:

    -   **id**        
        _Definition:_ This is an optional field that you do not have before the token is generated. But, after the token is created once the card details are added, then you will receive the customer ID in the response which can be handled in the onSuccess callback function.
    -   **name**        
        _Definition:_ Full Name of the customer paying.        
        _Fields:_  
        1.  **lang**        
        Definition: Language chosen to write the customer name.  
        2.  **first**        
        Definition: Customer's first name.  
        3.  **middle**        
        Definition: Customer's middle name.  
        4.  **last**        
        Definition: Customer's last name.

    -   **editable**        
        _Definition:_ The customer's name on the card he is paying with, also known as cardholder name.        
        Note: It is of type Boolean, and indicated whether or not the customer can edit the cardholder name already entered when the token got created.

    -   **contact**        
        _Definition:_ The customer's contact information like email address and phone number.        
        Note: The contact information has to either have the email address or the phone details of the customers or both but it should not be empty.        
        _Fields:_  
        1.  **email**        
        Definition: Customer's email address        
        Note: The email is of type string.  
        2.  **phone**        
        Definition: Customer's Phone number details  
        1.  **countryCode**  
        2.  **number**

-   **nameOnCard**        
    _Definition:_ Pre-fill the cardholder name already received once the payment form is submitted.
4.  _Example:_
```dart  
 "customer": {  "id": "",    
      "name": const [    
    {    
        "first": "TAP",    
        "middle": "",    
        "lang": "en",    
        "last": "PAYMENTS"    
    }    
  ],    
    "editable": true,    
    "contact": const {    
     "email": "tap@tap.company",    
        "phone": {    
           "countryCode": "+965",    
           "number": "88888888"    
     }    
  },    
    "nameOnCard": "",    
  }  
 ```  
## features[](https://developers.tap.company/docs/card-sdk-flutter#features)
1. Definition: Additional functionalities to be added in order to make the payment gateway experience more customisable for your needs, like showing the accepted card brands on the payment form, save card toggle button...
2. Type: Map<String,dynamic> (optional)
3. Fields:

    -   **acceptanceBadge**        
        _Definition:_ A boolean to indicate wether or not you want to display the list of supported card brands that appear beneath the card form itself.

    -   **customerCards**        
        _Definition:_ You will have the option to display either the toggle button that allows to save the card or the autosave card.        
        _Fields:_  
        1.  **saveCard**        
        Definition: A boolean to indicate wether or not you want to display the save card option to the customer.        
        Must be used with a combination of these 2 scopes either SaveToken or SaveAuthenticatedToken.  
        2.  **autoSave**        
        Definition: A boolean to indicate wether or not you want the save card switch to be on by default.

    -   **alternativeCardInput**        
        _Definition:_ You can also, either add the card information by scanning the card or by using NFC.        
        Note: In order for that to work, you will need to add the Camera usage description to your info.plist file like so
        ```xml <key>NSCameraUsageDescription</key> <string>Card SDK needs it for scanner functionality</string>
        ```
        _Fields:_ 1.  **cardScanner** Definition: A boolean to indicate whether or not you want to display the scan card icon.

5.  _Example:_
```dart  
 "features": {  "customerCards": {    
      "saveCard": true,    
      "autoSaveCard": true    
       },    
  "alternativeCardInputs": {    
      "cardScanner": true,    
      "cardNFC": false,    
      },    
  "acceptanceBadge": true,    
  }  
 ```   
## acceptance[](https://developers.tap.company/docs/card-sdk-flutter#acceptance)

1. Definition: This will help in controlling the supported payment schemes, like MasterCard and Visa, and the fund source either being debit or credit card and you will also be able to check if you want the customers to complete the 3DS phase (Authentication) or not. 2. Type: Dictionary (_optional_) 3. Fields:
    -   **supportedSchemes**        
        _Definition:_ A list to control which card schemes the customer can pay with, note that he can choose more than one card scheme.        
        _Possible Values:_
1. AMERICAN_EXPRESS  
   2. VISA  
   3. MASTERCARD  
   4. MADA  
   5. OMANNET

    -   **supportedFundSource**        
        _Definition:_ A list to control which card types are allowed by your customer.        
        _Possible Values:_
1. Debit  
   2. Credit

    -   **supportedPaymentAuthentications**        
        _Definition:_ A list of what authentication techniques you want to enforce like 3DS authentication        
        _Possible Values:_
1. 3DS

2. _Example:_
 ```dart   
 "acceptance": {    
    "supportedPaymentAuthentications":    
                ["3DS"],    
    "supportedFundSource": ["CREDIT","DEBIT"],    
    "supportedSchemes": [ "AMERICAN_EXPRESS", "MADA", "MASTERCARD", "VISA", "OMANNET"],    
  }  
```  

## fieldVisibility [](https://developers.tap.company/docs/card-sdk-flutter#fieldvisibility)
1. Definition: A boolean to indicate wether or not you want to show/collect the card holder name.
2. Type: Map<String,dynamic> (_optional_)
3. Fields:
    -   **card**
1.  **cardHolder**
- _Definition:_ The person that is paying using credit or debit card.  
  2. **cvv**
- _Definition:_ CVV number of the card.
4. _Example:_
```dart  
 fieldVisibility = {"card": {"cardHolder": true,"cvv": true,}}   
```
## interface [](https://developers.tap.company/docs/card-sdk-flutter#interface)

1. Definition: This will help you control the layout (UI) of the payment form, like changing the theme light to dark, the language used (en or ar), ...
2. Type: Dictionary (_optional_)
3. Fields:
    -   **loader**        
        _Definition:_ A boolean to indicate wether or not you want to show a loading view on top of the card form while it is performing api requests.
    -   **locale**        
        _Definition:_ The language of the card form. Accepted values as of now are:        
        _Possible Values:_
        1.  **en**(for english)
        2.  **ar**(for arabic).

    -   **theme**        
        _Definition:_ The display styling of the card form. Accepted values as of now are:        
        _Options:_    
        1.  **light**    
        2.  **dark**    
        3.  **dynamic** ( follow the device's display style )

    -   **edges**        
        _Definition:_ Control the edges of the payment form.        
        _Possible Values:_    
        1.  **curved**    
        2.  **flat**

-   **cardDirection**        
    _Definition:_ The layout of the fields (card logo, number, date & CVV) within the card element itself.        
    _Possible Values:_
    1.  **ltr**        
        Definition: The fields will inflate from left to right.
    2. **rtl**        
       **Definition: The fields will inflate from right to left.
    3.  **dynamic**        
        Definition: The fields will inflate in the locale's direction.

-   **colorStyle**        
    _Definition:_ How do you want the icons rendered inside the card form.        
    _Possible Values:_
    1.  **colored**
    2.  **monochrome** 4.
4. _Example:_
```dart "interface": {    
    "colorStyle": "colored",    
    "theme": "light",    
    "locale": "en",    
    "edges": "curved",    
    "cardDirection": "dynamic",    
    "loader": true    
}   
``` 
## post [](https://developers.tap.company/docs/card-sdk-flutter#post)

1. Definition: Here you can pass the webhook URL you have, in order to receive notifications of the results of each Transaction happening on your application.

2. Type: Dictionary (_optional_)

3. Fields:

    -   **url**        
        _Definition:_ The webhook server's URL that you want to receive notifications on.        
        _Example:_    
        ``` post = {"url":""} ``` # Expected Callbacks Responses[](https://developers.tap.company/docs/card-sdk-flutter#expected-callbacks-responses)
## onBinIdentification
 ```json
  { "bin": "557607", "bank": "COMMERCIAL INTERNATIONAL BANK (EGYPT) S.A.E.", "card_brand": "MASTERCARD", "card_type": "DEBIT", "card_category": "PLATINUM", "card_scheme": "MASTERCARD", "country": "EG", "address_required": false, "api_version": "V2", "issuer_id": "bnk_TS02A1320232208a5O41810531", "brand": "MASTERCARD"}   
``` 
## onSuccess
The response here will differ based on the scope:
### Token
```json
 { "id": "tok_4WUP3423199C4Vp18rY9y554", "created": 1697656174554, "object": "token", "live_mode": false, "type": "CARD", "purpose": "Transaction", "source": "CARD-ENCRYPTED", "used": false, "card": { "id": "card_U8Wb34231992m7q185g9i558", "object": "card", "address": {}, "funding": "CREDIT", "fingerprint": "gRkNTnMrJPtVYkFDVU485JtGPdhzQr%2FnmHGhlzLBvuc%3D", "brand": "VISA", "scheme": "VISA", "category": "", "exp_month": 2, "exp_year": 44, "last_four": "4242", "first_six": "424242", "first_eight": "42424242", "name": "AHMED", "issuer": { "bank": "", "country": "GB", "id": "bnk_TS05A3420232209Kp2j1810445" }      
 },"save_card": false, "url": ""}   
 ```   
## AuthenticatedToken
```json 
{ "id": "auth_payer_MhIp23231913vYjl18nx94755", "object": "Authenticate", "live_mode": false, "api_version": "V2", "status": "AUTHENTICATED", "created": "1697656409282", "amount": 1, "currency": "KWD", "save_card": false, "provider": {
  "name": "MPGS" },
  "transaction": {
    "timezone": "UTCZ", "created": "1697656409282" },
  "response": {
    "code": "000", "message": "Authentication Successful" },
  "reference": {
    "transaction": "tck_LV02G1720231634Xj51824647", "order": "ord_Tlh924231913OouS18vd9O487" },
  "customer": {
    "id": "", "name": [
      {
        "first_name": "test", "middle_name": "test", "last_name": "test", "locale": "en" }
    ],
    "name_on_card": "Ahmed", "email": "test@tap.com", "phone": {
      "country_code": "+20", "number": "1099137777" }
  },
  "source": {
    "id": "tok_RCiU23231913dWqQ18WV9Q18" },
  "merchant": {
    "id": "1124340" },
  "card": {
    "first_six": "424242", "scheme": "VISA", "brand": "VISA", "category": "", "last_four": "4242", "name": "AHMED", "expiry": {
      "month": "02", "year": "44" },
    "funding": "CREDIT" },
  "authentication": {
    "acsEci": "02", "card_enrolled": "Y", "authenticationToken": "jHyn+7YFi1EUAREAAAAvNUe6Hv8=", "transactionId": "h3q0bQzZNyBueA//+57RcpfPo6s=", "version": "3DS1", "channel": "PAYER_BROWSER", "purpose": "Transaction", "url": "https://authenticate.alpha.tap.company/redirect/auth_payer_MhIp23231913vYjl18nx94755",
    "transStatus": "Y", "mode": "C" },
  "redirect": {
    "url": "" } }   
```