

# Card-Flutter

We at [Tap Payments](https://www.tap.company/) strive to make your payments easier than ever. We as a PCI compliant company, provide you a from the self solution to process card payments in your Flutter apps.

![](https://img.shields.io/badge/platform-Flutter-blue)
![](https://img.shields.io/badge/pub-1.0.0-green)


## Getting started

In the  `pubspec.yaml`  of your flutter project, add the following dependency:

dependencies:
```dart
  card_flutter: 1.0.0
```
In your library add the following import:
```dart
import 'package:card_flutter/models/models.dart';
```

Then execute this in flutter terminal:
```
cd ios
pod install
pod update
```

## Minimum requirements
1. Dart version 3.0.0 +
2. Flutter version 3.0.0 +
3. iOS 13.0 +

# Steps overview
```mermaid
sequenceDiagram

participant  A  as  App
participant  T  as  Tap
participant  C  as  Card iOS

A->>T:  Regsiter app.
T-->>A: Public key.
A ->> C : Add the dependency
A ->> C : Add TapCardViewWidget
C -->> A : tapCardView
A ->> C : tapCardView(sdkConfiguration,callbacks)
C -->> A: onReady()
C -->> C : Enter card data
C -->> A : onBinIdentification(data)
C -->> A : onValidInput
A ->> C : tapCardView.generateToken()
C -->> A : onSuccess(data)
```

# Get your keys
You can always use the example keys within our example app, but we do recommend you to head to our [onboarding](https://register.tap.company/sell)  page. You will need to register your `bundle id` & `package id` to get your `Key` that you will need to activate our `Card-Flutter`.


# Prepare input

## Documentation

### Main input documentation
To make our sdk as dynamic as possible, we accept the input in a form of a `dictionary` . We will provide you with a sample full one for reference.
It is always recommended, that you generate this `dictionary` from your server side, so in future if needed you may be able to change the format if we did an update.

|Configuration|Description | Required | Type| Sample
|--|--|--| --|--|
| operator| This is the `Key` that you will get after registering you bundle id. | True  | Map| `{"operator": {"publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"}` |
| scope| Defines the intention of using the `Card-Flutter`. | True  | String| ` String scope = "Token"`|
| purpose| Defines the intention of using the `Token` after generation. | True  | String| String purpose = "asd"` |
| transaction| Needed to define transaction metadata and reference, if you are generating an authenticated token. | False  | `Map`| ` transaction = {"metadata":{"example":"value"}, "reference":"A reference to this transaciton in your system","paymentAgreement":{"id":"", "contract":{"id":"If you created a contract id with the client to save his card, pass its is here. Otherwise, we will create one for you."}}` |
| order| This is the `order id` that you created before or `amount` and `currency` to generate a new order.   It will be linked this token. | True  | `Map`| ` order = {"id":"", "amount":1, "currency":"SAR", "description": "Authentication description"}` |
| invoice| This is the `invoice id` that you want to link this token to if any. | False  | `Map`| ` invoice = {"id":""}` |
| merchant| This is the `Merchant id` that you will get after registering you bundle id. | True  | `Map`| ` merchant = {"id":""}` |
| customer| The customer details you want to attach to this tokenization process. | True  | `Map`| ` customer = {"id":"", "name":[{"lang":"en","first":"TAP","middle":"","last":"PAYMENTS"}], "nameOnCard":"TAP PAYMENTS", "editble":true, "contact":{"email":"tap@tap.company", "phone":{"countryCode":"+965","number":"88888888"}}}` |
| features| Some extra features that you can enable/disable based on the experience you want to provide.. | False  | `Map`| ` features = {"scanner":true, "acceptanceBadge":true, "customerCards":{"saveCard":false, "autoSaveCard":false}}`|
| acceptance| The acceptance details for the transaction. Including, which card brands and types you want to allow for the customer to tokenize/save. | False  | `Map`| `acceptance = {"supportedSchemes":["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA"], "supportedFundSource":["CREDIT","DEBIT"], "supportedPaymentAuthentications":["3DS"]}`|
| fields| Needed to define visibility of the optional fields in the card form. | False  | `Map`| ` fields = {"card":{"cardHolder":true}}` |
| addons| Needed to define the enabling of some addons on top of the basic card form. | False  | `Map`| ` addons = {"loader": true}`|
| interface| Needed to defines look and feel related configurations. | False  | `Map`| ` interface = {"locale": "en", "theme": "light", "edges": "curved", "direction": "dynamic", "powered": true, "colorStyle": "colored"}` |
| post| This is the `webhook` for your server, if you want us to update you server to server. | False  | `Map`| ` post = {"url":""}` |

### Documentation per variable

- operator:
    - Responsible for passing the data that defines you as a merchant within Tap system.
- operator.publicKey:
    - A string, which you get after registering the app bundle id within the Tap system. It is required to correctly identify you as a merchant.
    - You will receive a sandbox and a production key. Use, the one that matches your environment at the moment of usage.
- scope:
    - Defines the intention of the token you are generating.
    - When the token is used afterwards, the usage will be checked against the original purpose to make sure they are a match.
    - Possible values:
        -  `Token` : This means you will get a Tap token to use afterwards.
        - `AuthenticatedToken` This means you will get an authenticated Tap token to use in our charge api right away.
        - `SaveToken` This means you will get a token to use multiple times with authentication each time.
        - `SaveAuthenticatedToken` This means you will get an authenticated token to use in multiple times right away.
- purpose:
    - Defines the intention of using the `Token` after generation.
    - Possible values:
        - `PAYMENT_TRANSACTION` Using the token for a single charge.
        - `RECURRING_TRANSACTION` Using the token for multiple recurring charges.
        - `INSTALLMENT_TRANSACTION` Using the token for a charge that is a part of an installement plan.
        - `ADD_CARD` Using the token for a save a card for a customer.
        - `CARDHOLDER_VERIFICATION` Using the token for to verify the ownership of the card.
- transaction:
    - Provides essential information about this transaction.
- transaction.reference:
    - Pass this value if you want to link this transaction to the a one you have within your system.
- transaction.metadata:
    - It is a key-value based parameter. You can pass it to attach any miscellaneous data with this transaction for your own convenience.
- transaction.paymentAgreement.id:
    - The id the payment agreement you created using our Apis.
    - This is an agreement between you and your client to allow saving his card for further payments.
    - If not passed, it will be created on the fly.
- transaction.paymentAgreement.contract.id:
    - The id the contract you created using our Apis.
    - This is a contract between you and your client to allow saving his card for further payments.
    - If not passed, it will be created on the fly.
- order:
    - The details about the order that you will be using the token you are generating within.
- order.id:
    - The id of the `order` if you already created it using our apis.
- order.currency:
    - The intended currency you will perform the order linked to this token afterwards.
-  order.amount:
    - The intended amount you will perform the order linked to this token afterwards.
- order.description:
    - Optional string to put some clarifications about the order if needed.
- invoice.id:
    - Optional string to pass an invoice id, that you want to link to this token afterwards.
- merchant.id:
    - Optional string to pass to define a sub entity registered under your key in Tap. It is the `Merchant id` that you get from our onboarding team.
- customer.id:
    - If you have previously have created a customer using our apis and you want to link this token to him. please pass his id.
- customer.name:
    - It is a list of localized names. each name will have:
        - lang : the 2 iso code for the locale of this name for example `en`
        - first : The first name.
        - middle: The middle name.
        - last : The last name.
- customer.nameOnCard:
    - If you want to prefill the card holder's name field.
- customer.editable:
    - A boolean that controls whether the customer can edit the card holder's name field or not.
- customer.contact.email:
    - An email string for  the customer we are creating. At least the email or the phone is required.
- customer.contact.phone:
    - The customer's phone:
        - countryCode
        - number
- features:
    - Some extra features/functionalities that can be configured as per your needs.
- features.scanner:
    - A boolean to indicate whether or not you want to display the scan card icon.
    - Make sure you have access to camera usage, before enabling the scanner function.
- features.acceptanceBadge:
    - A boolean to indicate wether or not you want to display the list of supported card brands that appear beneath the card form itself.
- features.customerCards.saveCard:
    - A boolean to indicate wether or not you want to display the save card option to the customer.
    - Must be used with a combination of these scopes:
        - SaveToken
        - SaveAuthenticatedToken
- features.customerCards.autoSave:
    - A boolean to indicate wether or not you want the save card switch to be on by default.
- acceptance:
    - List of configurations that control the payment itself.
- acceptance.supportedSchemes:
    - A list to control which card schemes the customer can pay with. For example:
        - AMERICAN_EXPRESS
        - VISA
        - MASTERCARD
        - MADA
        - OMANNET
- acceptance.supportedFundSource:
    - A list to control which card types are allowed by your customer. For example:
        - DEBIT
        - CREDIT
- acceptance.supportedPaymentAuthentications:
    - A list of what authentication techniques you want to enforce and apple. For example:
        - 3DS
- fields.card.cardHolder:
    - A boolean to indicate wether or not you want to show/collect the card holder name.
- addons.loader:
    - A boolean to indicate wether or not you want to show a loading view on top of the card form while it is performing api requests.
- interface.locale:
    - The language of the card form. Accepted values as of now are:
        - en
        - ar
- interface.theme:
    - The display style of the card form. Accepted values as of now are:
        - light
        - dark
        - dynamic // follow the device's display style
- interface.edges:
    - How do you want the edges of the card form to. Accepted values as of now are:
        - curved
        - flat
- interface.cardDirection:
    - The layout of the fields (card logo, number, date & CVV) within the card element itself. Accepted values as of now are:
        - ltr // fields will inflate from left to right
        - rtl // fields will inflate from right to left
        - dynamic // fields will inflate in the locale's direction
- interface.powered:
    - A boolean to indicate wether or not you want to show powered by tap.
    - Note, that you have to have the permission to hide it from the integration team. Otherwise, you will get an error if you pass it as false.
- interface.colorStyle:
    - How do you want the icons rendered inside the card form to. Accepted values as of now are:
        - colored
        - monochrome

## Initialisation of the widget

You will pass the configurations & the callbacks while declaring your widget in your widgets' hierarchy.

```dart
TapCardViewWidget(
              sdkConfiguration: const {
                "features": {
                  "customerCards": {"saveCard": true, "autoSaveCard": true},
                  "alternativeCardInputs": {"cardScanner":true,"cardNFC":false},
                  "acceptanceBadge": true,
                },
                "post": {"url": ""},
                "customer": {
                  "id": "",
                  "name": [
                    {
                      "first": "TAP",
                      "middle": "",
                      "lang": "en",
                      "last": "PAYMENTS"
                    }
                  ],
                  "editable": true,
                  "contact": {
                    "email": "tap@tap.company",
                    "phone": {"countryCode": "+965", "number": "88888888"}
                  },
                  "nameOnCard": "TAP PAYMENTS"
                },
                "fieldVisibility": {
                  "card": {"cardHolder": true, "cvv": true}
                },
                "merchant": {"id": ""},
                "interface": {
                  "powered": true,
                  "colorStyle": "monochrome",
                  "theme": "light",
                  "locale": "en",
                  "edges": "curved",
                  "cardDirection": "dynamic",
                  "loader": true
                },
                "purpose": "Transaction",
                "operator": {"publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"},
                "scope": "SaveToken",
                "order": {
                  "description": "Authentication description",
                  "currency": "KWD",
                  "amount": 1,
                  "id": "",
                  "reference":"",
                  "metadata":{}
                }
                "invoice": {"id": ""},
                "acceptance": {
                  "supportedPaymentAuthentications": ["3DS"],
                  "supportedFundSource": ["CREDIT", "DEBIT"],
                  "supportedSchemes": [
                    "AMERICAN_EXPRESS",
                    "VISA",
                    "MASTERCARD",
                    "OMANNET",
                    "MADA"
                  ]
                }
              },
              onReady: () {
                debugPrint(">ON READY FIRED FROM CALLBACK");
              },
              onFocus: () {
                setState(() {
                  generateToken = false;
                });
                debugPrint(">ON FOCUS FIRED FROM CALLBACK");
              },
              onSuccess: (String? success) {
                debugPrint(">ON SUCCESS FIRED FROM CALLBACK >>>>>> $success");
                setState(() {
                  mCardSDKResponse = success.toString();
                });
              },
              onValidInput: (String? validInput) {
                debugPrint(
                    ">ON VALID INPUT FIRED FROM CALLBACK >>>>>> $validInput");
                setState(() {
                  mCardSDKResponse = validInput.toString();
                });
              },
              onHeightChange: (String? heightChange) {
                debugPrint(
                    ">ON HEIGHT CHANGE FIRED FROM CALLBACK >>>>>> $heightChange");
              },
              onBindIdentification: (String? bindIdentification) {
                debugPrint(
                    ">ON BIND IDENTIFICATION FIRED FROM CALLBACK >>>>>> $bindIdentification");
              },
              onError: (String? error) {
                debugPrint(">ON ERROR FIRED FROM CALLBACK >>>>>> $error");
              },
              generateToken: generateToken,
            )

```

### Callbacks
In the above example, we have shown how many callbacks you can pass to the widget. Let us have a brief about each

```dart
/// Will be fired whenever the card is rendered and loaded
void onReady(){}
/// Will be fired once the user focuses any of the card fields
void onFocus(){}
/// Will be fired once we detect the brand and related issuer data for the entered card data
    /** - Parameter data: will include the data in JSON format. example :
     *{
        "bin": "424242",
        "bank": "",
        "card_brand": "VISA",
        "card_type": "CREDIT",
        "card_category": "",
        "card_scheme": "VISA",
        "country": "GB",
        "address_required": false,
        "api_version": "V2",
        "issuer_id": "bnk_TS02A5720231337s3YN0809429",
        "brand": "VISA"
     }*     */
String onBinIdentification(){}
 /// Will be fired whenever the validity of the card data changes.
    /// - Parameter bool: Will be true if the card data is valid and false otherwise.
String onValidInputFunction(){}
/**
        Will be fired whenever the card sdk finishes successfully the task assigned to it. Whether `TapToken` or `AuthenticatedToken`
     - Parameter data: will include the data in JSON format. For `TapToken`:
     {
         "id": "tok_MrL97231045SOom8cF8G939",
         "created": 1694169907939,
         "object": "token",
         "live_mode": false,
         "type": "CARD",
         "source": "CARD-ENCRYPTED",
         "used": false,
         "card": {
             "id": "card_d9Vj7231045akVT80B8n944",
             "object": "card",
             "address": {},
             "funding": "CREDIT",
             "fingerprint": "gRkNTnMrJPtVYkFDVU485Gc%2FQtEo%2BsV44sfBLiSPM1w%3D",
             "brand": "VISA",
             "scheme": "VISA",
             "category": "",
             "exp_month": 4,
             "exp_year": 24,
             "last_four": "4242",
             "first_six": "424242",
             "name": "AHMED",
             "issuer": {
                "bank": "",
                "country": "GB",
                "id": "bnk_TS07A0720231345Qx1e0809820"
            }
         },
         "url": ""
     }
     */
String onSuccess(){}   
/// Will be fired whenever there is an error related to the card connectivity or apis
    /// - Parameter data: includes a JSON format for the error description and error
String onError(){}

```

# Tokenize the card


`generateToken` state variable

On demand, whenever you want to the card sdk to generate a token, you will need to pass `generateToken: true` in the widget declaration. Best practice is to have it as a stateful variable.
The example is indicated above.


