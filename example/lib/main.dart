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
        "0000000", "Text Appear hear");
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
            TextButton(
              child: Text("Share to facebook button"),
              onPressed: () {
                shareOnFacebook();
              },
            ),
            TextButton(
              child: Text("Share to instagram button"),
              onPressed: () {
                shareOnInstagram();
              },
            ),
            TextButton(
              child: Text("Share to whatsapp button"),
              onPressed: () {
                shareWatsapp();
              },
            ),
            TextButton(
              child: Text("Share to email button"),
              onPressed: () {
                shareEmail();
              },
            ),
            TextButton(
              child: Text("Share to sms button"),
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
