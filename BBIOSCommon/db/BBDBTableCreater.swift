//
//  BBDBTableCreater.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/5/25.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import SQLite

//public struct TableInfo{
//    let name: String
//    var columns: Array<ColumnInfo<>>
//    
//    init(name: String){
//        self.name = name
//        columns = Array()
//    }
//}
//
//public struct ColumnInfo<V>{
//    let name: Expression<V>
//    let isPrimaryKey: Bool
//    
//    init(name: Expression<V>){
//        self.name = name
//        isPrimaryKey = false
//    }
//}
//
//public class BBDBTableCreater{
//    
//    public class func createTable(db: Database, tableInfo: TableInfo){
//        let table = db[tableInfo.name]
//        db.create(table: table){ newTable in
//            for columnInfo in tableInfo.columns{
//                newTable.column(columnInfo.name, primaryKey: columnInfo.isPrimaryKey)
//            }
//        }
//    }
//    
//}
