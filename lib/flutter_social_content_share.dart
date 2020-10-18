import 'dart:async';
import 'package:flutter/services.dart';

enum ShareType { facebookWithoutImage, instagramWithImageUrl, more }

class FlutterSocialContentShare {
  static const MethodChannel _channel =
      const MethodChannel('flutter_social_content_share');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> share(
      {ShareType type,
      String quote,
      String url,
      String imageName,
      String imageUrl}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "type": type.toString(),
      "quote": quote,
      "url": url,
      "imageName": imageName,
      "imageUrl": imageUrl
    };
    final String message = await _channel.invokeMethod('share', params);
    return message;
  }
}
