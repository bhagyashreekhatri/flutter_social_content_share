import 'dart:async';
import 'package:flutter/services.dart';

enum ShareType { facebookWithoutImage, instagramWithImageUrl, more }

class FlutterSocialContentShare {
  static const MethodChannel _channel =
      const MethodChannel('flutter_social_content_share');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> share(
      {ShareType? type,
      String? quote,
      String? url,
      String? imageName,
      String? imageUrl}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "type": type.toString(),
      "quote": quote,
      "url": url,
      "imageName": imageName,
      "imageUrl": imageUrl
    };
    final String? message = await _channel.invokeMethod('share', params);
    return message;
  }

  static Future<String?> shareOnWhatsapp(String number, String text) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "number": number,
      "text": text
    };
    final String? message =
        await _channel.invokeMethod('shareOnWhatsapp', params);
    return message;
  }

  static Future<String?> shareOnSMS({List? recipients, String? text}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "recipients": recipients,
      "text": text
    };
    final String? message = await _channel.invokeMethod('shareOnSMS', params);
    return message;
  }

  static Future<String?> shareOnEmail(
      {List? recipients,
      List? ccrecipients,
      List? bccrecipients,
      String? subject,
      String? body,
      bool? isHTML}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "recipients": recipients,
      "subject": subject,
      "ccrecipients": ccrecipients,
      "bccrecipients": bccrecipients,
      "body": body,
      "isHTML": isHTML,
    };
    final String? message = await _channel.invokeMethod('shareOnEmail', params);
    return message;
  }
}
