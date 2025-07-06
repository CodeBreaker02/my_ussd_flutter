#import "UssdAdvancedPlugin.h"

@implementation UssdAdvancedPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
            methodChannelWithName:@"method.com.phan_tech/ussd_advanced"
                  binaryMessenger:[registrar messenger]];
    UssdAdvancedPlugin* instance = [[UssdAdvancedPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"sendUssd" isEqualToString:call.method]) {
        NSString* number = call.arguments[@"code"];
        [self directCall:number completion:^(BOOL success) {
            result(@(success));
        }];
    }else if ([@"sendAdvancedUssd" isEqualToString:call.method]) {
        NSString* number = call.arguments[@"code"];
        [self directCall:number completion:^(BOOL success) {
            result(@(success));
        }];
    }else if ([@"multisessionUssd" isEqualToString:call.method]) {
        NSString* number = call.arguments[@"code"];
        [self directCall:number completion:^(BOOL success) {
            result(@(success));
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)directCall:(NSString*)number completion:(void(^)(BOOL success))completion {
    // Use the newer percent encoding method
    number = [number stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    if (![number hasPrefix:@"tel:"]) {
        number = [NSString stringWithFormat:@"tel:%@", number];
    }

    NSURL *url = [NSURL URLWithString:number];

    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        if (completion) {
            completion(NO);
        }
        return;
    }

    // Use the new non-deprecated method
    [[UIApplication sharedApplication] openURL:url
                                       options:@{}
                             completionHandler:^(BOOL success) {
                                 if (completion) {
                                     completion(success);
                                 }
                             }];
}

@end