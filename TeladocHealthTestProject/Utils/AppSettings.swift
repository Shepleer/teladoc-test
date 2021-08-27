//
//  AppSettings.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 26/08/2021.
//

import Foundation

class AppSettings {
    static let shared = AppSettings()
    
    var backendUrl: String
    
    private init() {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path) as! [AnyHashable: Any]
        let settings = plist["AppSettings"] as! [AnyHashable: Any]
        self.backendUrl = settings["BackendUrl"] as! String
    }
}
