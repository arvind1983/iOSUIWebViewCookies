Cordova plugin or UIWebView to save and load HTTP Cookies.

The plugin structure is based on 
---
# Cordova Plugin Example

Use of Plugin:

Config.xml <plugin name="cordova-plugin-example" source="git" spec="https://github.com/arvind1983/iOSUIWebViewCookies"/>

//onResume

setTimeout(function() { uiwebviewcookies.loadHTTPCookies(null,null); }, 0);

// onDeviceReady 

setTimeout(function() { uiwebviewcookies.loadHTTPCookies(null,null); }, 0);

// Save during app init

setTimeout(function() { uiwebviewcookies.saveHTTPCookies(null,null); }, 0);
