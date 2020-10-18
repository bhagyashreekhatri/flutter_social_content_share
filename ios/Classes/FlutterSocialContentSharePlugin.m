#import "FlutterSocialContentSharePlugin.h"
#if __has_include(<flutter_social_content_share/flutter_social_content_share-Swift.h>)
#import <flutter_social_content_share/flutter_social_content_share-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_social_content_share-Swift.h"
#endif

@implementation FlutterSocialContentSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSocialContentSharePlugin registerWithRegistrar:registrar];
}
@end
