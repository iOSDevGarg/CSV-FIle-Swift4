//
//  ReadContent.swift
//  MitoCalc
//
//  Created by IosDeveloper on 13/11/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//

import UIKit

class ReadContent: NSObject {
    var name : String = ""
    var recordString : String = ""
    var date : String = ""
    var time : String = ""
    
    override init() {
    }
    
    func initWithData(data: [[String]],index: Int){
        let newData = data[index]
        recordString = newData[0]
        name = newData[1]
        date = newData[2]
        time = newData[3]        
    }
    
}


