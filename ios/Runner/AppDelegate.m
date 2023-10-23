#import "AppDelegate.h"
@import Firebase;

@implementation AppDelegate

- (BOOL)application:(UIApplication )application didFinishLaunchingWithOptions:(NSDictionary )launchOptions {
    // Initialize Firebase
    [FIRApp configure];

    // Track source and medium
    [self trackGoogleAnalyticsTrafficSourceMediumWithLaunchOptions:launchOptions];

    // Other app initialization code

    return YES;
}

- (void)trackGoogleAnalyticsTrafficSourceMediumWithLaunchOptions:(NSDictionary *)launchOptions {
    // Extract source and medium from the URL parameters (if available)
    NSDictionary *sourceMediumDictionary = [self extractSourceMediumFromLaunchOptions:launchOptions];

    if (sourceMediumDictionary) {
        NSString *source = sourceMediumDictionary[@"utm_source"];
        NSString *medium = sourceMediumDictionary[@"utm_medium"];

        if (source && medium) {
            // Track the source and medium using Google Analytics
            [FIRAnalytics logEventWithName:@"traffic_source" parameters:@{
                @"source": source,
                @"medium": medium
            }];
        }
    }
}

- (NSDictionary )extractSourceMediumFromLaunchOptions:(NSDictionary )launchOptions {
    // Check if the app was launched via a URL
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];

    if (url) {
        // Extract query parameters from the URL
        NSString *query = [url query];
        NSArray *queryComponents = [query componentsSeparatedByString:@"&"];

        NSMutableDictionary *sourceMediumDictionary = [NSMutableDictionary dictionary];

        // Parse query parameters and extract source and medium
        for (NSString *component in queryComponents) {
            NSArray *keyValue = [component componentsSeparatedByString:@"="];

            if (keyValue.count == 2) {
                NSString *key = keyValue[0];
                NSString *value = keyValue[1];
                sourceMediumDictionary[key] = value;
            }
        }

        return sourceMediumDictionary;
    }

    return nil;
}

// Other AppDelegate methods

@end
