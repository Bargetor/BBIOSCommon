//
//  BBDBManager.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/5/25.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation
import SQLite

public class BBDBManager{
    private let db: Database
    
    init(dbPath: String){
        self.db = Database(dbPath)
    }
}