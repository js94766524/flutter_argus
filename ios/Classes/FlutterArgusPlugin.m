#import "FlutterArgusPlugin.h"
#import <flutter_argus/flutter_argus-Swift.h>

@implementation FlutterArgusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterArgusPlugin registerWithRegistrar:registrar];
}
@end
