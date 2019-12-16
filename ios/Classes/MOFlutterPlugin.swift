import Flutter
import UIKit
import MoEngage

public class MOFlutterPlugin: NSObject, FlutterPlugin {
    
    private static var channel : FlutterMethodChannel? = nil
    private static var channelInitialized : Bool = false
    private static var messageQueue : Array<MOFlutterMessage> = Array()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: MOFlutterConstants.kPluginChannelName, binaryMessenger: registrar.messenger())
        let instance = MOFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }
    
    // MARK:- Handle Invocation
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case MOFlutterConstants.MethodNames.kTrackEvent:
            trackEvent(call)
        case MOFlutterConstants.MethodNames.kSetAlias:
            setAlias(call)
        case MOFlutterConstants.MethodNames.kSetUserAttribute:
            setUserAttribute(call)
        case MOFlutterConstants.MethodNames.kSetUserAttributeTimestamp:
            setUserAttributeTimestamp(call)
        case MOFlutterConstants.MethodNames.kSetUserAttributeLocation:
            setUserAttributeLocation(call)
        case MOFlutterConstants.MethodNames.kShowInApp:
            MoEngage.sharedInstance().handleInAppMessage()
        case MOFlutterConstants.MethodNames.kResetUser:
            MoEngage.sharedInstance().resetUser()
        case MOFlutterConstants.MethodNames.kSetAppStatus:
            setAppStatus(call)
        case MOFlutterConstants.MethodNames.kRegisterForPush:
            registerForPushNotification()
        case MOFlutterConstants.MethodNames.kInitializeFlutter:
            MOFlutterPlugin.initializedFlutterPlugin()
        default:
            print("Invalid method invoked: \(call.method)")
        }
    }
    
    private static func initializedFlutterPlugin(){
        channelInitialized = true
        if messageQueue.count > 0 {
            for msg in messageQueue {
                self.invokeChannelCallback(msg.msgMethodName, withInfo: msg.msgInfoDict)
            }
        }
        messageQueue.removeAll()
    }
    
    // MARK:- App Status Tracking
    private func setAppStatus(_ call: FlutterMethodCall){
        if let arguments = call.arguments as? [String: Any],let appStatus = arguments[MOFlutterConstants.ArgumentKeys.kAttributeValue] as? String{
            
            if appStatus == "INSTALL" {
                MoEngage.sharedInstance().appStatus(INSTALL)
            }
            else{
                MoEngage.sharedInstance().appStatus(UPDATE)
            }
        }
    }
    
    // MARK:- Data Tracking
    private func trackEvent(_ call: FlutterMethodCall){
        
        if let arguments = call.arguments as? [String: Any]{
            let eventName = arguments[MOFlutterConstants.ArgumentKeys.kAttributeEventName] as? String
            let eventAttributes = arguments[MOFlutterConstants.ArgumentKeys.kAttributeEventAttrs] as? [String: Any]
            guard let _ = eventName, let _ = eventAttributes else {
                return
            }
            
            let payloadBuilder = MOPayloadBuilder()
            
            if let generalAttributes = eventAttributes![MOFlutterConstants.ArgumentKeys.kAttributeEventGeneralAttrs] as? NSMutableDictionary {
                payloadBuilder.eventDict = generalAttributes
            }
            
            if let timestampAttributes = eventAttributes![MOFlutterConstants.ArgumentKeys.kAttributeEventDateAttrs] as? Dictionary<String,String> {
                for (attrName,isoDateStr) in timestampAttributes {
                    if let date = self.getDateFromISOStr(isoDateStr){
                        payloadBuilder.setDate(date, forKey: attrName)
                    }
                }
            }
            
            if let locationAttributes = eventAttributes![MOFlutterConstants.ArgumentKeys.kAttributeEventLocationAttrs] as? Dictionary<String,Dictionary<String,Double>> {
                
                for (attrName,locationDict) in locationAttributes {
                    if let latVal = locationDict[MOFlutterConstants.ArgumentKeys.kAttributeLatValue], let lngVal = locationDict[MOFlutterConstants.ArgumentKeys.kAttributeLngValue]{
                        payloadBuilder.setLocationLat(latVal, lng: lngVal, forKey: attrName)
                    }
                }
            }
            
            if let isNonInteractive = eventAttributes![MOFlutterConstants.ArgumentKeys.kAttributeIsNonInteractive] as? Bool {
                if isNonInteractive {
                    payloadBuilder.setNonInteractive()
                }
            }
            
            MoEngage.sharedInstance().trackEvent(eventName!, builderPayload: payloadBuilder)
        }
    }
    
    func setAlias(_ call: FlutterMethodCall){
        if let arguments = call.arguments as? [String: Any], let newUniqueId = arguments[MOFlutterConstants.ArgumentKeys.kAttributeValue] {
             MoEngage.sharedInstance().setAlias(newUniqueId)
        }
    }

    func setUserAttribute(_ call: FlutterMethodCall) {
        if let arguments = call.arguments as? [String: Any], let attributeName = arguments[MOFlutterConstants.ArgumentKeys.kAttributeName] as? String {
            let attributeValue = arguments[MOFlutterConstants.ArgumentKeys.kAttributeValue]
            MoEngage.sharedInstance().setUserAttribute(attributeValue, forKey: attributeName)
        }
    }
    
    func setUserAttributeTimestamp(_ call: FlutterMethodCall){
        if let arguments = call.arguments as? [String: Any], let attributeName = arguments[MOFlutterConstants.ArgumentKeys.kAttributeName] as? String {
            let attributeValue = arguments[MOFlutterConstants.ArgumentKeys.kAttributeValue] as? String
            if let date = self.getDateFromISOStr(attributeValue){
                MoEngage.sharedInstance().setUserAttributeTimestamp(date.timeIntervalSince1970, forKey: attributeName)
            }
        }
    }
    
    func setUserAttributeLocation(_ call: FlutterMethodCall){
        if let arguments = call.arguments as? [String:Any], let attributeName = arguments[MOFlutterConstants.ArgumentKeys.kAttributeName] as? String,  let latitudeValue = arguments[MOFlutterConstants.ArgumentKeys.kAttributeLatValue] as? Double, let longitudeValue = arguments[MOFlutterConstants.ArgumentKeys.kAttributeLngValue] as? Double  {
            MoEngage.sharedInstance().setUserAttributeLocationLatitude(latitudeValue, longitude: longitudeValue, forKey: attributeName)
        }
    }
    
    // MARK:- Push Notifications
    private func registerForPushNotification(){
        if #available(iOS 10.0, *) {
            MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: UNUserNotificationCenter.current().delegate)
        } else {
            MoEngage.sharedInstance().registerForRemoteNotificationForBelowiOS10(withCategories: nil)
        };
    }
    
    // MARK:- Utils
    private func getDateFromISOStr(_ isoDateStr : String?) -> Date? {
        guard let _ = isoDateStr else {
            return nil
        }
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone      = TimeZone.init(abbreviation: "GMT")
        dateFormatter.locale        = Locale.init(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: isoDateStr!){
            return date
        }
    
        return nil
    }
    
    //MARK:- Callbacks to dart
    
    internal static func sendCallback(_ callbackName: String, withInfo infoDict: Dictionary<String,Any>){
        var infoMutableDict = infoDict
        infoMutableDict["platform"] = "ios"
        if (channelInitialized) {
            self.invokeChannelCallback(callbackName, withInfo: infoMutableDict)
        }
        else{
            print("MoEngage -- \(MOFlutterConstants.kPluginChannelName) not initialized yet")
            let msg = MOFlutterMessage.init(methodName: callbackName, infoDict: infoMutableDict)
            messageQueue.append(msg)
        }
    }
    
    private static func invokeChannelCallback(_ callbackName: String, withInfo infoDict: Dictionary<String,Any>){
        channel?.invokeMethod(callbackName, arguments: infoDict)
    }
    
}
