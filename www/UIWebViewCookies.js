var exec = require('cordova/exec');

exports.echo = function(arg0, success, error) {
    exec(success, error, "UIWebViewCookies", "echo", [arg0]);
};

exports.getCookies = function(success, error) {
    exec(success, error, "UIWebViewCookies", "getCookies");
};

exports.saveHTTPCookies = function(success, error) {
    exec(success, error, "UIWebViewCookies", "saveHTTPCookies");
};

exports.loadHTTPCookies = function(success, error) {
    exec(success, error, "UIWebViewCookies", "loadHTTPCookies");
};

exports.deleteAllCookies = function(success, error) {
    exec(success, error, "UIWebViewCookies", "DeleteAllCookies");
};

exports.echojs = function(arg0, success, error) {
    if (arg0 && typeof(arg0) === 'string' && arg0.length > 0) {
        success(arg0);
    } else {
        error('Empty message!');
    }
};
