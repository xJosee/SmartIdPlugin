var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    console.log("JS cool method init");
    exec(success, error, 'SmartIdPlugin', 'coolMethod', [arg0]);
};

exports.initSmartId = function (arg0, success, error) {
    exec(success, error, 'SmartIdPlugin', 'initSmartId', arg0);
};

exports.linkSmartId = function (arg0, success, error) {
    console.log(arg0);
    exec(success, error, 'SmartIdPlugin', 'linkSmartId', arg0);
};

exports.unLinkSmartId = function (arg0, success, error) {
    exec(success, error, 'SmartIdPlugin', 'unLinkSmartId', arg0);
};

exports.smartCoreOperation = function (arg0, success, error) {
    exec(success, error, 'SmartIdPlugin', 'smartCoreOperation', arg0);
};

exports.startSmartId = function (arg0, success, error) {
    exec(success, error, 'SmartIdPlugin', 'startSmartId', arg0);
};

