//
//  ApiKeys.swift
//  Weather
//
//  Created by Jacob C. Irons on 11/22/21.
//

import Foundation


func valueForAPIKey(keyName:String) -> String {
    let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    let value = plist?.object(forKey: keyName) as! String
    return value
}
