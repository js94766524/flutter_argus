import Flutter
import UIKit
import CoreTelephony

public class SwiftFlutterArgusPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_argus", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterArgusPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getInfo":
            result(getInfo())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    
    private func getInfo()->Dictionary<String,String>{
        var map = Dictionary<String,String>()
        let device = UIDevice.current
        var un = utsname()
        uname(&un)
        map["osid"] = device.identifierForVendor?.uuidString ?? ""
        map["build_ts"] = ""
        map["brand"] = "Apple"
        map["model"] = device.model
        map["mktname"] = "Apple"
        map["device"] = device.name
        map["product"] = unToString(un.machine)
        map["osver"] = unToString(un.version)
        map["osname"] = unToString(un.sysname)
        map["api"] = device.systemVersion
        map["timezone"] = NSTimeZone.local.identifier
        map["pkn"] = Bundle.main.bundleIdentifier
        map["ver"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        map["vcode"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        let mnoInfo = CTTelephonyNetworkInfo()
        if let carrier = mnoInfo.subscriberCellularProvider{
            map["mno"] = (carrier.mobileCountryCode ?? "***") + (carrier.mobileNetworkCode ?? "**")
        }
        map["lang"] = NSLocale.preferredLanguages.first
        return map
    }
    
    private func unToString(_ un:Any)->String{
        let machineMirror = Mirror(reflecting: un)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
