/* UIWebViewCookies.m */

#import "UIWebViewCookies.h"
#import <Cordova/CDV.h>

@implementation UIWebViewCookies

- (void)echo:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* msg = [command.arguments objectAtIndex:0];

    if (msg == nil || [msg length] == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {
        
        UIAlertView *toast = [
            [UIAlertView alloc] initWithTitle:@"Echo"
            message:msg
            delegate:nil
            cancelButtonTitle:nil
            otherButtonTitles:nil, nil];

        [toast show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showMessageAlert:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
        
    UIAlertView *toast = [
            [UIAlertView alloc] initWithTitle:@"Cookies"
            message:@"getting cookies"
            delegate:nil
            cancelButtonTitle:nil
            otherButtonTitles:nil, nil];

        [toast show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)loadHTTPCookies:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];

    for (int i=0; i < cookieDictionary.count; i++)
    {
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    // Alert cookies found
    if(cookieDictionary.count>0)
    {
        UIAlertView *toast = [
            [UIAlertView alloc] initWithTitle:@"Cookies"
            message:@"Found UIWebView cookies!"
            delegate:nil
            cancelButtonTitle:nil
            otherButtonTitles:nil, nil];

        [toast show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
       
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)saveHTTPCookies:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.name];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithUnsignedInteger:cookie.version] forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];

        [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }

    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)deleteAllCookies:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
