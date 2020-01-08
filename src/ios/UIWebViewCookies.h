/* UIWebViewCookies.h */

#import <Cordova/CDV.h>

@interface UIWebViewCookies : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand*)command;
- (void)showMessageAlert:(CDVInvokedUrlCommand*)command;
- (void)saveHTTPCookies:(CDVInvokedUrlCommand*)command;
- (void)loadHTTPCookies:(CDVInvokedUrlCommand*)command;
- (void)deleteAllCookies:(CDVInvokedUrlCommand*)command;
- (void)testParams:(CDVInvokedUrlCommand*)command;
@end
