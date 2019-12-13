/* UIWebViewCookies.h */

#import <Cordova/CDV.h>

@interface UIWebViewCookies : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand*)command;
- (void)showMessageAlert:(CDVInvokedUrlCommand*)command;
- (void)saveHTTPCookies:(CDVInvokedUrlCommand*)command;
- (void)loadHTTPCookies:(CDVInvokedUrlCommand*)command;
- (void)DeleteAllCookies:(CDVInvokedUrlCommand*)command;
@end
