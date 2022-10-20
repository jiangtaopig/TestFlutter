#import "FirstPlugin.h"
#if __has_include(<first_plugin/first_plugin-Swift.h>)
#import <first_plugin/first_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "first_plugin-Swift.h"
#endif

@implementation FirstPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFirstPlugin registerWithRegistrar:registrar];
}
@end
