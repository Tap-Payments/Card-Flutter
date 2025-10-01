## 1.0.19 24-09-2025

* Support android 15

## ProGuard Rules

If you're using ProGuard in your Android project, add the following rules to your ProGuard configuration file:

```proguard
# Card Flutter ProGuard Rules
# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

-dontwarn com.bumptech.glide.Glide
-dontwarn com.bumptech.glide.RequestBuilder
-dontwarn com.bumptech.glide.RequestManager
-dontwarn com.bumptech.glide.request.target.ViewTarget

-keep class company.tap.tapnetworkkit.** { *; }
-keep class com.tap.** { *; }
-keep class com.tap.commondatamodels.** { *; }
```

## 1.0.18 24-09-2025
* Support android 15

## 1.0.17 24-09-2025

* Support android 15

## 1.0.16 06-08-2025

* Fix android firebase dependency

## 1.0.15 02-06-2025

* Fix android NFC 

## 1.0.14 05-05-2025

* Fix android crash issue when user move from portrait to landscape mode

## 1.0.13 21-APR-2025

* Fix android crash issue when using scanner with card reader

## 1.0.12 21-APR-2025

* Fix android Scanner Crash issue

## 1.0.11 1-MAR-2025

* Fix eventSink payload in onChangeSaveCard method to reflect correct enabled state

## 1.0.10 27-FEB-2025

* Enhance example app
* Android SDK updated
* iOS SDK updated
* Add save card option callback

## 1.0.9 20-FEB-2025

* Android SDK updated
* iOS SDK updated
* Add save card option callback

## 1.0.8 07-Aug-2024

* Android SDK updated
* Duplicated class/variables names issue fixed

## 1.0.7 13-June-2024

* Android SDK updated
* iOS SDK updated
* Merchant Id is required now

## 1.0.6 06-June-2024

* Configuration updated, enhancements done

## 1.0.5 25-Jan-2024

* Android SDK updated.
* Update to latest android card sdk version with handling of ssl
* Bug fixes

## 1.0.4 24-Jan-2024

* Android SDK updated.
* iOS SDK updated

## 1.0.3

* Android SDK updated.

## 1.0.2

* Bug fixes for Android SDK.

## 1.0.1

* iOS SDK updated.

## 1.0.0

* Initial release of card_flutter.