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
    NSInteger *cookieCount = 0;
    NSMutableString * aTitleString = [NSMutableString stringWithFormat:@"Found %d", cookieCount];    // does not need to be released. Needs to be retained if you need to keep use it after the current function.
    
    NSMutableString *myCookie = [NSMutableString stringWithString:@"Cookies: "];
    
    // Dictionary to store cookie name and values temporarily and pass to JS table
    NSMutableDictionary *cookieJSDictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    for (int i=0; i < cookieDictionary.count; i++)
    {
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
        //myCookie = [[cookieDictionary1 valueForKey:@"NSHTTPCookieName"] componentsJoinedByString:@", "];
        //myCookie = [myCookie stringByAppendingString:cookie.name];
        NSString* cookieName = [cookie valueForKey:@"name"];
        NSString* cookieVal = [cookie valueForKey:@"value"];
        
        [cookieJSDictionary setObject:cookieVal forKey:cookieName];
        //[cookieJSDictionary setObject:cookieVal forKey:@"value"];
         
        myCookie = [myCookie stringByAppendingString:cookieName];
        myCookie = [myCookie stringByAppendingString:@", "];
        myCookie = [myCookie stringByAppendingString:cookieVal];
        myCookie = [myCookie stringByAppendingString:@", "];
    }
    cookieCount = cookieDictionary.count;
    [aTitleString appendFormat:@"cookies: %d", cookieCount];
    // Alert cookies found
    if(cookieDictionary.count>0)
    {
        UIAlertView *toast = [
            [UIAlertView alloc] initWithTitle:aTitleString
            //message:@"Found UIWebView cookies!"
            message:myCookie
            delegate:nil
            cancelButtonTitle:nil
            otherButtonTitles:nil, nil];

        //[toast show]; // temporarily hide the toast
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
       
    //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:cookieDictionary];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:cookieJSDictionary];

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
        
    // alert stuffs
    NSInteger *cookieCount = 0;
    NSMutableString * aTitleString = [NSMutableString stringWithFormat:@"Deleted %d", cookieCount];    // does not need to be released. Needs to be retained if you need to keep use it after the current function.
    
    NSMutableString *myCookie = [NSMutableString stringWithString:@"Cookies: "];
       
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    for (int i=0; i < cookieDictionary.count; i++)
    {
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //myCookie = [[cookieDictionary1 valueForKey:@"NSHTTPCookieName"] componentsJoinedByString:@", "];
        myCookie = [myCookie stringByAppendingString:cookie.name];
        myCookie = [myCookie stringByAppendingString:@", "];
        //myCookie = @"test";
    }
    
    cookieCount = cookieDictionary.count;
    [aTitleString appendFormat:@"cookies: %d", cookieCount];
    
    // Clear NSUserdefaults standardUserDefaults to remove "cookieArray" and others
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Remove the localstorage db
    NSString *path = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Backups"] stringByAppendingPathComponent:@"localstorage.appdata.db"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];

    //Also remove the cached versions
    path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    for (NSString *string in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]) {
        if ([[string pathExtension] isEqualToString:@"localstorage"]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
    
    UIAlertView *toast = [
            [UIAlertView alloc] initWithTitle:aTitleString
            message:myCookie
            delegate:nil
            cancelButtonTitle:nil
            otherButtonTitles:nil, nil];

        //[toast show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses]; // remove all cache responses
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)testParams:(CDVInvokedUrlCommand*)command
{
     CDVPluginResult *pluginResult = nil;
     NSString *param = @"test params";
     pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:param];
     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId]; 
}

@end
