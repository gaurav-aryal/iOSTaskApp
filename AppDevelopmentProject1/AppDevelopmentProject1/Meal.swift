//
//  Meal.swift
//  AppDevelopmentProject1
//
//  Created by Gaurav Aryal on 2/16/20.
//  Copyright © 2020 Gaurav Aryal. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject{
    
    //MARK: Properties
    var name: String
    var datePicker: String
    var doneSwitch: Bool
    //var date: Date

    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let datePicker = "datePicker"
        static let doneSwitch = "doneSwitch"
        
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    init?(name: String, datePicker: String, doneSwitch: Bool) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        guard !datePicker.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.datePicker = datePicker
        self.doneSwitch = doneSwitch
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(datePicker, forKey: PropertyKey.datePicker)
        aCoder.encode(datePicker, forKey: PropertyKey.doneSwitch)
        //Coder.encode(date, forKey: PropertyKey.date)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
       guard let datePicker = aDecoder.decodeObject(forKey: PropertyKey.datePicker) as? String else {
            os_log("Unable to decode the date for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let doneSwitch = aDecoder.decodeObject(forKey: PropertyKey.datePicker) as? Bool else {
            os_log("Unable to decode the is done switch for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else { return nil }
        
        // Must call designated initializer.
        self.init(name: name, datePicker: datePicker, doneSwitch: doneSwitch)
    }
}
