# Tap-Card-SDK-Flutter
We at [Tap Payments](https://www.tap.company/) strive to make your payments easier than ever. We as a PCI compliant company, provide you a from the self solution to process card payments in your iOS and android apps.

# Get your Tap keys
You can always use the example keys within our example app, but we do recommend you to head to our [onboarding](https://register.tap.company/sell)  page. You will need to register your `bundle id` to get your `Tap Key` that you will need to activate our `Card SDK`.

# Installation
We got you covered, `TapCardSDK` can be installed with all possible technologies.
---

<a name="installation_with_pubspec"></a>

### Include tapCardFlutterSDK plugin as 
a dependency in your pubspec.yaml

```dart
 dependencies:
     tap_card_flutter: ^latest tag
```

---

# Prepare input

## Documentation

To make our sdk as dynamic as possible, we do accept many configurations as input. Let us start by declaring them and explaining the structure and the usage of each.
```dart
/**

Creates a configuration model to be passed to the SDK

- Parameters:

	- publicKey: The Tap public key

	- scope: The scope of the card sdk. Default is generating a tap token

	- purpose: The intended purpose of using the generated token afterwards.
	- transaction: The transaction details

	- order: The tap order id

	- invoice: Link this token to an invoice

	- merchant: The Tap merchant details

	- customer: The Tap customer details

	- acceptance: The acceptance details for the transaction

	- fields: Defines the fields visibility

	- addons: Defines some UI/UX addons enablement

	- interface: Defines some UI related configurations

*/
```

|Configuration|Description | Required | Type| Sample
|--|--|--| --|--|
| publicKey| This is the `Tap Key` that you will get after registering you package name. | True  | String| `var publicKey:String = "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"` |
| scope| Defines the intention of using the `TapCardSDK`. | True  | `Scope` enum| ` var scope:Scope = Scope.Token //This means you will get a Tap token to use afterwards` OR ` var scope:Scope = Scope.Authenticate //This means you will get an authenticated Tap token to use in our charge api right away`  |
| merchant| This is the `Merchant id` that you will get after registering you package name. | True  | `Merchant`| ` var merchant:Merchant = Merchant(id= "")` |
| transaction| Needed to define the amount and the currency, if you are generating an authenticated token. | False  | `Transaction`| ` var transaction:Transaction = Transaction(amount= 1, currency= "SAR")` |
| authentication| If you want to generate an authenticated token, which allows you to perform charges without any further 3DS in our [Charge api](https://developers.tap.company/reference/create-a-charge). Moreover, please create an order first, with our Order api to get `Order id` & `Transaction id` | False  | `Authentication`| ` var authentication:Authentication = Authentication(description= "Authentication description", metadata:HashMap = metadata.put("utf1","data"), reference: Reference(transaction=  "Your transaction id", order= "Your order id"), invoice: Invoice(id= "If have an invoice id to attach"), authentication: AuthenticationClass(), post: Post(url="Your server webhook if needed"))` |
| customer| The customer details you want to attach to this tokenization process. | True  | `Customer`| ` var customer:Customer = Customer(id= "If you have a tap customer id", name= [Name(lang: "en", first: "Tap", last: "Payments", middle: "")], nameOnCard= "Tap Payments", editable= **true**, contact: Contact(email= "tappayments@tap.company", phone= Phone(countryCode= "+965", number= "88888888")))` |
| acceptance| The acceptance details for the transaction. Including, which card brands and types you want to allow for the customer to tokenize. | False  | `Acceptance`| ` var  acceptance:Acceptance = Acceptance(supportedBrands=["AMERICAN_EXPRESS","VISA","MASTERCARD","OMANNET","MADA", "MEEZA"], supportedCards= ["CREDIT","DEBIT"])` |
| fields| Needed to define visibility of the optional fields in the card form. | False  | `Fields`| ` var fields:Fields = Fields(cardHolder= true)` |
| addons| Needed to define the enabling of some extra features on top of the basic card form. | False  | `Addons`| ` var addons:Addons = Addons(displayPaymentBrands= true, loader= true,scanner= true)` `/**- displayPaymentBrands: Defines to show the supported card brands logos - loader: Defines to show a loader on top of the card when it is in a processing state - scanner: Defines whether to enable card scanning functionality or not*/`|
| interface| Needed to defines look and feel related configurations. | False  | `Interface`| ` var  interface:Interface = Interface(locale= "en", theme= "light", edges= "curved", direction= "dynamic")` |

## Initialization of the input

### Initialize as a  Dictionary as HashMap
You can create a Dictionary HashMap to pass the data to our sdk. The good part about this, is that you can generate the data from one of your apis. Whenever we have an update to the configurations, you can update your api. This will make sure, that you will not have to update your app on the Google Play Store.
```dart
sdkConfigurations = <String, dynamic>{
      "id": merchant,
      "amount": transactionAmount,
      "currency": transactionCurrency,
      "countryCode": phoneCountryCode,
      "number": phoneNumber,
      "email": contactEmail,
      "lang": nameLang,
      "first": nameFirst,
      "middle": nameMiddle,
      "last": nameLast,
      "nameOnCard": customerNameOnCard,
      "editable": customerEditable,
      "supportedBrands": acceptanceSupportedBrands,
      "supportedCards": acceptanceSupportedCards,
      "cardHolder": fieldsCardHolder,
      "loader": addonsLoader,
      "saveCard": addonsSaveCard,
      "displayPaymentBrands": addonsDisplayPaymentBrands,
      "scanner": addonsScanner,
      "nfc": addonsNFC,
      "transaction": referenceTransaction,
      "order": referenceOrder,
      "channel": authChannel,
      "purpose": authPurpose,
      "invoiceId": invoiceID,
      "postId": postID,
      "description": authenticationDescription,
      "locale": interfaceLocale,
      "theme": interfaceTheme,
      "edges": interfaceEdges,
      "direction": interfaceDirection,
      "publicKey": publicKey,
      "scope": scope,
    };

```
# Initializing the TapCardSDK form

```dart
  // CardForm Widget from TapCardSDK
  static Widget tapCardSDKView({
    required double height,
  }) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        height: height,
        child: AndroidView(
          viewType: "plugin/tap_card_sdk",
          creationParams: TapCardSdkFlutter.sdkConfigurations,
          creationParamsCodec: const StandardMessageCodec(),
          layoutDirection: TextDirection.ltr,
        ),
      );
    }
    return const SizedBox();
  }
```