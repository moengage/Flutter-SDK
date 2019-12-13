//
//  MOFlutterMessage.swift
//  flutter_moengage_plugin
//
//  Created by Chengappa C D on 13/12/19.
//

import Foundation

internal class MOFlutterMessage {
    public private(set) var msgMethodName : String
    public private(set) var msgInfoDict : Dictionary<String,Any>
    
    init(methodName: String, infoDict : Dictionary<String,Any>) {
        self.msgMethodName = methodName
        self.msgInfoDict   = infoDict
    }
}

