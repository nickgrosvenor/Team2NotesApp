//
//  Database.swift
//  SwiftDatabaseDemo
//
//  Created by Upendra Patel on 07/01/15.
//  Copyright (c) 2015 Upendra Patel. All rights reserved.
//

import Foundation
import UIKit



class Database {
    
     var DBBUSY: Int = 0
     var database_name:NSString = "ImageData.rdb"
     
    init()
    {
        
    }
    
    func createEditableCopyOfDatabaseIfNeeded()
    {
        
        var success: Bool
        var error: NSError? = nil
    
        let fileManager = NSFileManager.defaultManager()
        let writableDBPath = database_name.pathInDocumentDirectory()
        
        success = fileManager.fileExistsAtPath(writableDBPath)
        if success
        {
            return
        }
        var defaultDBPath:NSString?

        defaultDBPath = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(database_name)
        fileManager.copyItemAtPath(defaultDBPath!, toPath: writableDBPath, error: &error)
    }
    
    
//    +(NSString* )getDatabasePath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *writableDBPath = nil;
//    writableDBPath= [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
//    return writableDBPath;
//    
//    }

    
    func getDatabasePath() -> NSString
    {
        let documentsDirectory:NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let writableDBPath = documentsDirectory.stringByAppendingPathComponent(database_name)
        return writableDBPath
    }

//    +(BOOL)executeScalerQuery:(NSString*)str{
//    str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
//    sqlite3_stmt *statement= nil;
//    BOOL bRet = NO;
//    sqlite3 *database;
//    NSString *strPath = [self getDatabasePath];
//    while(DBBUSY);
//    DBBUSY = 1;
//    if (sqlite3_open([strPath UTF8String],&database) == SQLITE_OK) {
//    if (sqlite3_prepare_v2(database, [str UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//    if (sqlite3_step(statement) == SQLITE_DONE) {
//				bRet = YES;
//    }
//    sqlite3_finalize(statement);
//    }
//    }
//    DBBUSY = 0;
//    sqlite3_close(database);
//    return bRet;
//    }
    
    
    func executeScalerQuery(str:String)-> Bool
    {
        var str:String = str.stringByReplacingOccurrencesOfString("<null>", withString: "")
        str = str.stringByReplacingOccurrencesOfString("(null)", withString: "")
        var statement : COpaquePointer = nil
        var bRet:Bool = false
        var database:COpaquePointer = nil
        var strPath = self.getDatabasePath()
        
        while Bool(DBBUSY){}
        
        DBBUSY = 1
        
        if sqlite3_open(strPath.UTF8String, &database) == SQLITE_OK
        {
            let cStr = str.cStringUsingEncoding(NSUTF8StringEncoding)
            let prepare = sqlite3_prepare_v2(database, cStr!, -1, &statement, nil)
            if prepare != SQLITE_OK {
                sqlite3_finalize(statement)
                if let error = String.fromCString(sqlite3_errmsg(database)) {
                    let msg = "SQLiteDB - failed to prepare SQL: \(str), Error: \(error)"
                    println(msg)
                }
                return bRet
            }
            else    //if prepare == SQLITE_OK
            {
                if sqlite3_step(statement) == SQLITE_DONE
                {
                    bRet = true
                }
                sqlite3_finalize(statement)
            }
        }
        DBBUSY = 0
        sqlite3_close(database)
        return bRet
    }
    
  
    
//    +(NSMutableArray *)executeQuery:(NSString*)str{
//    sqlite3_stmt *statement= nil;
//    sqlite3 *database;
//    NSString *strPath = [self getDatabasePath];
//    while(DBBUSY);
//    DBBUSY = 1;
//    NSMutableArray *allDataArray = [[[NSMutableArray alloc] init] autorelease];
//    if (sqlite3_open([strPath UTF8String],&database) == SQLITE_OK) {
//    if (sqlite3_prepare_v2(database, [str UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//    while (sqlite3_step(statement) == SQLITE_ROW) {
//				NSInteger i = 0;
//				NSInteger iColumnCount = sqlite3_column_count(statement);
//				NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//				while (i< iColumnCount) {
//                    NSString *str = [self encodedString:(const unsigned char*)sqlite3_column_text(statement, i)];
//                    NSString *strFieldName = [self encodedString:(const unsigned char*)sqlite3_column_name(statement, i)];
//                    if(!str)
//                      str = @"";
//                    [dict setObject:str forKey:strFieldName];
//                    i++;
//				}
//				[allDataArray addObject:dict];
//				[dict release];
//    }
//    }
//    DBBUSY = 0;
//    
//    sqlite3_finalize(statement);
//    }
//    sqlite3_close(database);
//    return allDataArray;
//    }

    func executeQuery(str:String)-> [Dictionary<String,String>]
    {
        var statement : COpaquePointer = nil
        var database:COpaquePointer = nil
        var strPath = self.getDatabasePath()
        while Bool(DBBUSY){}
        DBBUSY = 1
        var allDataArray:Array = [Dictionary<String,String>]()
        if sqlite3_open(strPath.UTF8String, &database) == SQLITE_OK
        {
            if sqlite3_prepare_v2(database, str.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, &statement, nil) == SQLITE_OK
            {
                while sqlite3_step(statement) == SQLITE_ROW
                {
                    var i:Int32 = 0
                    var iColumnCount = sqlite3_column_count(statement)
                    var dict = Dictionary<String,String>()
                    while i < iColumnCount
                    {
                        
//                        var result: UnsafePointer<UInt8> = sqlite3_column_text(statement, i)
                        var str:UnsafePointer<UInt8> = sqlite3_column_text(statement, i)
                        
//                        var result1: ConstUnsafePointer<UInt8> = sqlite3_column_text(statement, i)
//                        let str: CString = CString(UnsafePointer<UInt8>(result))

//                        var str = self.encodedString(sqlite3_column_text(statement, iCol: i))
//                        let strFieldName:String = self.encodedString(sqlite3_column_name(statement, i))
                        
                        var strValue :String = String.fromCString(UnsafePointer<CChar>(str))!
                        let strFieldName = sqlite3_column_name(statement, i)
                         //var str,strFieldName :String
                        var strFieldNameKey:String = String.fromCString(UnsafePointer<CChar>(strFieldName))!
                        if str == nil
                        {
                            strValue = ""
                        }
                        dict[strFieldNameKey] = strValue
                        i++
                    }
                    allDataArray.append(dict)
                }
            }
            DBBUSY = 0
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        return allDataArray
    }
    
//    +(NSString*)encodedString:(const unsigned char *)ch
//    {
//    NSString *retStr;
//    if(ch == nil)
//    retStr = @"";
//    else
//    retStr = [NSString stringWithCString:(char*)ch encoding:NSUTF8StringEncoding];
//    return retStr;
//    }

    func encodedString(ch:CUnsignedChar!)-> String
    {
        var retStr:String
        
        if ch == nil
        {
            retStr = ""
        }
        else
        {
            var commandsToPrint:CUnsignedChar=ch
            retStr=NSString(format: "%c", commandsToPrint)
            print("Database retStr :",&retStr)

        }
            return retStr
    }
    
    
//    +(void)update:(NSString*)table data:(NSMutableDictionary*)dict{
//    NSString *query = [NSString stringWithFormat:@"update %@ SET ",table];
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for(NSString *key in [dict allKeys]){
//    NSString *strValue = [NSString stringWithFormat:@"%@ ='%@'",key,[dict objectForKey:key]];
//    [array addObject:strValue];
//    }
//    query = [query stringByAppendingFormat:@"%@",[array componentsJoinedByString:@","]];
//    [Database executeQuery:query];
//    [array release];
//    array = nil;
//    }

    
    func update(table:NSString, dict:Dictionary<String, String>)
    {
        var query:String = "update \(table) SET"
        var arrayData = Array<String>()
        var key:String
        var value:String
        for (key,value) in dict
        {
            var strValue = "\(key) = '\(value)'"
            
            arrayData.append(strValue)
        }
        var strJoinKey = join(",", arrayData)
        query = "\(query)\(strJoinKey)"
//        Database.executeQuery(query)
        self.executeQuery(query)
//        arrayData = nil
    }
    
//    +(void)insert:(NSString*)table data:(NSMutableDictionary*)dict{
//    NSString *query = [NSString stringWithFormat:@"Insert Into %@ (",table];
//    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
//    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
//    for(NSString *key in [dict allKeys]){
//    [keyArray addObject:key];
//    [dataArray addObject:[NSString stringWithFormat:@"'%@'",[dict objectForKey:key]]];
//    }
//    query = [query stringByAppendingFormat:@"%@) values (%@)",[keyArray componentsJoinedByString:@","],[dataArray componentsJoinedByString:@","]];
//    [Database executeQuery:query];
//    
//    [dataArray release];
//    dataArray = nil;
//    [keyArray release];
//    keyArray= nil;
//    }

    
    func insert(table:String, dict:Dictionary<String, String>)
    {
        var query = "Insert Into \(table) ("
//        var key:String
       
        var key:String
        var value:String
        
        var keyArray = Array(dict.keys)
        var dataArray = Array(dict.values)
//        keyArray(dict.keys)
//        dataArray(dict.values)
//        for (key,value) in dict
//        {
//            keyArray.append(key as NSString)
//            var strData = "'\(dict.valueForKey(key))'"
//            dataArray.append(strData)
//        }
        var strJoinKeys = join(",", keyArray)
        var strJoinData = join(",", dataArray)
        var strTempqry = "\(strJoinKeys) ) values (\(strJoinData))"

    }
    
}

