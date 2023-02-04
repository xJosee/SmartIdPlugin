import Foundation
import SmartId

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(SmartIdPlugin) class SmartIdPlugin: CDVPlugin {

    private let implementation = SmartIdPlugin()

    @objc(initSmartId:)
    func initSmartId(command: CDVInvokedUrlCommand) {

        let license : String = String(describing: command.arguments[0]);
        let username : String = String(describing: command.arguments[1]);
        //let myBool = (self as NSString).boolValue
        let isProduction : Bool = (String(describing: command.arguments[2]) as NSString).boolValue
        SID.start(license: license, username: username, isProduction: isProduction)
        print("Init smart id swift method");
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(linkSmartId:)
    func linkSmartId(command: CDVInvokedUrlCommand) {
        let channel : String = String(describing: command.arguments[0]);
        let session : String = String(describing: command.arguments[1]);
        SID.shared.link(channel: channel, session: session)

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(unlinkSmartId:)
    func unlinkSmartId(command: CDVInvokedUrlCommand) {
        let channel : String = String(describing: command.arguments[0]);
        let session : String = String(describing: command.arguments[1]);
        SID.shared.unlink(channel: channel, session: session)

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(smartCoreOperation:)
    func smartCoreOperation(command: CDVInvokedUrlCommand) {
        print(command.arguments[0]);
        print(command.arguments[1]);
        print(command.arguments[2]);
        print(command.arguments[3]);
        var operation : String = String(describing: command.arguments[1]);
        let newOperation = operation.dropFirst(9).dropLast(1);
        let channel : String = String(describing: command.arguments[3]);
        let jsonData = Data(newOperation.utf8);
        let decoder = JSONDecoder();
        
        var beer = try! decoder.decode(CoreOperation.self, from: jsonData)
                
        let newAccount = Account(client: beer.account?.client ?? "", clientRefId: 0, clientRefIdStr: "", email: "", phoneNumber: "", session: "", accountNumber: "", bank: "")
        let client = newAccount.client;
        
        beer.account?.client = client;
        
        SID.shared.createOperation(channel: channel, operation: beer);

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
    
    @objc(startSmartId:)
    func startSmartId(command: CDVInvokedUrlCommand) {
        SID.startLocation()

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

}


extension String {
    func sha256() -> String {

            if let stringData = self.data(using: String.Encoding.utf8) {
                return hexStringFromData(input: digest(input: stringData as NSData))
            }
            return ""
        }

        

        private func digest(input: NSData) -> NSData {

            let digestLength = Int(CC_SHA256_DIGEST_LENGTH)

            var hash = [UInt8](repeating: 0, count: digestLength)

            

            CC_SHA256(input.bytes, UInt32(input.length), &hash)

            

            return NSData(bytes: hash, length: digestLength)

        }

        

        private  func hexStringFromData(input: NSData) -> String {

            var bytes = [UInt8](repeating: 0, count: input.length)

            

            input.getBytes(&bytes, length: input.length)

            

            var hexString = ""

            

            for byte in bytes {
                hexString += String(format:"%02x", UInt8(byte))
            }
            return hexString

        }
}