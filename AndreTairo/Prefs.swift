//
//  Prefs.swift
//  AndreTairo
//
//  Created by Vinicius Torres on 01/10/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class Prefs {
    // MARK: - SharedPrefs Keys
    static let KEY_DOLAR = "KEY_DOLAR"
    static let KEY_IOF = "KEY_IOF"
    
    static func getPrefs() -> UserDefaults {
        return UserDefaults.standard
    }
    
    //dolar
    static func setDolarValue(_ dolarValue: Double?) {
    let prefs = getPrefs()
    prefs.setValue(dolarValue, forKey: KEY_DOLAR)
    prefs.synchronize()
    }
    
    static func getDolarValue() -> Double? {
    return getPrefs().double(forKey: KEY_DOLAR)
    }
    
    //iof
    static func setIOF(_ iof: Double?) {
    let prefs = getPrefs()
    prefs.setValue(iof, forKey: KEY_IOF)
    prefs.synchronize()
    }
    
    static func getIOF() -> Double? {
    return getPrefs().double(forKey: KEY_IOF)
    }
    
}


