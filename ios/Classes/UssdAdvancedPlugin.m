#import "UssdAdvancedPlugin.h"

@implementation UssdAdvancedPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSLog(@"[USSD_DEBUG] Registering UssdAdvancedPlugin with registrar");
    FlutterMethodChannel* channel = [FlutterMethodChannel
            methodChannelWithName:@"method.com.phan_tech/ussd_advanced"
                  binaryMessenger:[registrar messenger]];
    UssdAdvancedPlugin* instance = [[UssdAdvancedPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    NSLog(@"[USSD_DEBUG] UssdAdvancedPlugin registration completed successfully");
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"[USSD_DEBUG] Received method call: %@", call.method);
    NSLog(@"[USSD_DEBUG] Method arguments: %@", call.arguments);

    if ([@"sendUssd" isEqualToString:call.method]) {
        NSString* number = call.arguments[@"code"];
        NSLog(@"[USSD_DEBUG] Processing sendUssd with code: %@", number);
        [self directCall:number completion:^(BOOL success) {
            NSLog(@"[USSD_DEBUG] sendUssd completed with success: %@", success ? @"YES" : @"NO");
            result(@(success));
        }];
    }else if ([@"sendAdvancedUssd" isEqualToString:call.method]) {
        NSString* number = call.arguments[@"code"];
        NSLog(@"[USSD_DEBUG] Processing sendAdvancedUssd with code: %@", number);
        [self directCall:number completion:^(BOOL success) {
            NSLog(@"[USSD_DEBUG] sendAdvancedUssd completed with success: %@", success ? @"YES" : @"NO");
            result(@(success));
        }];
    }else if ([@"multisessionUssd" isEqualToString:call.method]) {
        NSString* number = call.arguments[@"code"];
        NSLog(@"[USSD_DEBUG] Processing multisessionUssd with code: %@", number);
        [self directCall:number completion:^(BOOL success) {
            NSLog(@"[USSD_DEBUG] multisessionUssd completed with success: %@", success ? @"YES" : @"NO");
            result(@(success));
        }];
    } else {
        NSLog(@"[USSD_DEBUG] Unknown method called: %@", call.method);
        result(FlutterMethodNotImplemented);
    }
}

- (void)directCall:(NSString*)number completion:(void(^)(BOOL success))completion {
    NSLog(@"[USSD_DEBUG] directCall started with number: %@", number);

    // Check if number is nil or empty
    if (!number || [number length] == 0) {
        NSLog(@"[USSD_DEBUG] ERROR: Number is nil or empty");
        if (completion) {
            completion(NO);
        }
        return;
    }

    // Use the newer percent encoding method
    NSString* originalNumber = number;
    number = [number stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"[USSD_DEBUG] Number after percent encoding: %@ (original: %@)", number, originalNumber);

    if (![number hasPrefix:@"tel:"]) {
        number = [NSString stringWithFormat:@"tel:%@", number];
        NSLog(@"[USSD_DEBUG] Added tel: prefix. Final number: %@", number);
    } else {
        NSLog(@"[USSD_DEBUG] Number already has tel: prefix: %@", number);
    }

    NSURL *url = [NSURL URLWithString:number];
    NSLog(@"[USSD_DEBUG] Created URL: %@", url);

    if (!url) {
        NSLog(@"[USSD_DEBUG] ERROR: Failed to create URL from string: %@", number);
        if (completion) {
            completion(NO);
        }
        return;
    }

    // Check if the URL can be opened
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    NSLog(@"[USSD_DEBUG] canOpenURL result: %@", canOpen ? @"YES" : @"NO");

    if (!canOpen) {
        NSLog(@"[USSD_DEBUG] ERROR: Cannot open URL: %@", url);
        if (completion) {
            completion(NO);
        }
        return;
    }

    NSLog(@"[USSD_DEBUG] Attempting to open URL: %@", url);

    // Use the new non-deprecated method
    [[UIApplication sharedApplication] openURL:url
                                       options:@{}
                             completionHandler:^(BOOL success) {
                                 NSLog(@"[USSD_DEBUG] openURL completion handler called with success: %@", success ? @"YES" : @"NO");
                                 if (completion) {
                                     NSLog(@"[USSD_DEBUG] Calling completion handler with success: %@", success ? @"YES" : @"NO");
                                     completion(success);
                                 } else {
                                     NSLog(@"[USSD_DEBUG] WARNING: No completion handler provided");
                                 }
                             }];

    NSLog(@"[USSD_DEBUG] openURL call initiated, waiting for completion...");
}

@end