//
//  Result.swift
//  CSV-File-Swift4
//
//  Created by IosDeveloper on 14/11/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//

import Foundation

final class ResultValues {
    //Static Object
    static let csvFileValue = ResultValues()
    
    private init() {
    }
    
    //all values
    var Name : String = ""
    var Date: String = ""
    var time: String = ""
    var Value1: String = ""
    var Value2: String = ""
    var Value3: String = ""
    
}
