//
//  Env.swift
//  SwiftCharts
//
//  Created by ischuetz on 07/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

class Env {
    
    //Check if its iPad
    static var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
