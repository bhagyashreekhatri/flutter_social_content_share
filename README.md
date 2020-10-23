# flutter_social_content_share
Flutter Plugin for sharing contents to social media.

## Introduction

It supports both the platforms `Android` and `iOS`

It provides you with most of the popular sharing options.
With this plugin you can share on instagram stories and facebook stories.

## Usage

### Android Configuration

#### Paste the following attribute in the `manifest` tag in the `android/app/src/main/AndroidManifest.xml`:

```
         `xmlns:tools="http://schemas.android.com/tools"`
```

##### For example:

```
        <manifest xmlns:android="http://schemas.android.com/apk/res/android"
                xmlns:tools="http://schemas.android.com/tools"
                package="your package...">
```

#### Add this piece of code in the `manifest/application` in the `android/app/src/main/AndroidManifest.xml`:

```
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.SEND_SMS" />
    
    <meta-data
            android:name="com.facebook.sdk.ApplicationId"
            android:value="@string/facebook_app_id" />

        <provider
            android:name="com.facebook.FacebookContentProvider"
            android:authorities="com.facebook.app.FacebookContentProvider[facebook_app_id]"
            android:exported="false" />
```

#### Create a xml file named `styles.xml` in the `app/src/main/res/values/styles.xml` folder and paste this code in the file :

```
<string name="facebook_app_id">xxxxxxxxxx</string>
```

### iOS Configuration

#### Add this to your `Info.plist` to use share on instagram and facebook story

```
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>fbapi</string>
        <string>fbauth</string>
        <string>fbauth2</string>
        <string>fbshareextension</string>
        <string>fbapi20130214</string>
        <string>fbapi20130410</string>
        <string>fbapi20130702</string>
        <string>fbapi20131010</string>
        <string>fbapi20131219</string>
        <string>fbapi20140410</string>
        <string>fbapi20140116</string>
        <string>fbapi20150313</string>
        <string>fbapi20150629</string>
        <string>instagram</string>
        <string>instagram-stories</string>
        <string>whatsapp</string>
    </array>
  
  <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Allow $(PRODUCT_NAME) access to your photo library to upload your profile picture?</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Allow $(PRODUCT_NAME) access to your photo library to upload your profile picture?</string>
  
```

### Add this if you are using share on facebook. For this you have to create an app on https://developers.facebook.com/ and get the App ID

```
<key>FacebookAppID</key>
<string>xxxxxxxxxxxxxxx</string>

<key>FacebookDisplayName</key>
    <string>My App</string>
```

### Add the below code which will help you in opening the facebook on webpage. If your facebook app is not installed in your device."xxxxxxxxxxxxxxx" represents your facebook app id.

```
<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>xxxxxxxxxxxxxxx</string>
            </array>
        </dict>
    </array>
  
```

#### shareOnInstagram

```
FlutterSocialContentShare.share(
        type: ShareType.instagramWithImageUrl,
        imageUrl:
            "https://post.healthline.com/wp-content/uploads/2020/09/healthy-eating-ingredients-732x549-thumbnail-732x549.jpg");
```

#### shareOnFacebook

```
FlutterSocialContentShare.share(
        type: ShareType.facebookWithoutImage,
        url: "https://www.apple.com",
        quote: "captions");
```


#### shareOnSMS

```
FlutterSocialContentShare.shareOnSMS(
    recipients: ["xxxxxx"], text: "Text appears here");

```

#### shareOnEmail

```
FlutterSocialContentShare.shareOnEmail(
    recipients: ["xxxx.xxx@gmail.com"],
    subject: "Subject appears here",
    body: "Body appears here",
    isHTML: true); //default isHTML: False

```

#### shareOnWhatsapp

```
FlutterSocialContentShare.shareOnWhatsapp(
    number: "xxxxxx", text: "Text appears here");

```

## Example

```
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterSocialContentShare.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  /// SHARE ON FACEBOOK CALL
  shareOnFacebook() async {
    String result = await FlutterSocialContentShare.share(
        type: ShareType.facebookWithoutImage,
        url: "https://www.apple.com",
        quote: "captions");
    print(result);
  }

  /// SHARE ON INSTAGRAM CALL
  shareOnInstagram() async {
    String result = await FlutterSocialContentShare.share(
        type: ShareType.instagramWithImageUrl,
        imageUrl:
            "https://post.healthline.com/wp-content/uploads/2020/09/healthy-eating-ingredients-732x549-thumbnail-732x549.jpg");
    print(result);
  }

  /// SHARE ON WHATSAPP CALL
  shareWatsapp() async {
    String result = await FlutterSocialContentShare.shareOnWhatsapp(
        number: "xxxxxx", text: "Text appears here");
    print(result);
  }

  /// SHARE ON EMAIL CALL
  shareEmail() async {
    String result = await FlutterSocialContentShare.shareOnEmail(
        recipients: ["xxxx.xxx@gmail.com"],
        subject: "Subject appears here",
        body: "Body appears here",
        isHTML: true); //default isHTML: False
    print(result);
  }

  /// SHARE ON SMS CALL
  shareSMS() async {
    String result = await FlutterSocialContentShare.shareOnSMS(
        recipients: ["xxxxxx"], text: "Text appears here");
    print(result);
  }

  ///Build Context
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            RaisedButton(
              child: Text("Share to facebook button"),
              color: Colors.red,
              onPressed: () {
                shareOnFacebook();
              },
            ),
            RaisedButton(
              child: Text("Share to instagram button"),
              color: Colors.red,
              onPressed: () {
                shareOnInstagram();
              },
            ),
            RaisedButton(
              child: Text("Share to whatsapp button"),
              color: Colors.red,
              onPressed: () {
                shareWatsapp();
              },
            ),
            RaisedButton(
              child: Text("Share to email button"),
              color: Colors.red,
              onPressed: () {
                shareEmail();
              },
            ),
            RaisedButton(
              child: Text("Share to sms button"),
              color: Colors.red,
              onPressed: () {
                shareSMS();
              },
            ),
          ],
        ),
      ),
    );
  }
}

```

