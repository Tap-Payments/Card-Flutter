# card_flutter_example_spm

The Card-Flutter example app, integrated with **Swift Package Manager** on iOS.

It shows the same card screen as [`../example`](../example), which uses CocoaPods.
Here the plugin and its Card-iOS dependency come in as Swift packages: the iOS
project has no `Podfile`.

Run it with a Flutter version that uses Swift Package Manager for iOS plugins
(on by default in recent Flutter releases; tested with Flutter 3.47):

```bash
cd example_spm
flutter run
```
