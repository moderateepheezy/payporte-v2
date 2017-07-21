//
// SQCursor.swift
//
// Copyright (c) 2015 Ryan Fowler
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

// MARK: SDCursor

public class SQCursor {
    
    private weak var database: SQDatabase?
    private var pStmt: OpaquePointer?
    private let sqlStr: String
    private lazy var columnNames: [String: Int32] = {
        [unowned self] in
        var dict: [String: Int32] = [:]
        let count = sqlite3_column_count(self.pStmt)
        
        
        for i in 0 ..< count {
          let colName = String.init(describing: sqlite3_column_name(self.pStmt, i))
            dict[colName] = i
        }
        return dict
    }()
    
    init(statement: OpaquePointer, fromDatabase db: SQDatabase, withSQL: String) {
        database = db
        pStmt = statement
        sqlStr = withSQL
    }
    
    deinit {
        close()
    }
    
    /**
    Returns true if another row exists
    */
    public func next() -> Bool {
    
        let status = sqlite3_step(pStmt)
        if status != SQLITE_ROW {
            if status == SQLITE_DONE {
                return false
            }
            if let dbPointer = database?.database {
                SQError.printSQLError("While stepping through SQLite statement: \(sqlStr)", errCode: status, errMsg: String.fromCString(sqlite3_errmsg(dbPointer)))
                return false
            }
            SQError.printSQLError(main: "While stepping through SQLite statement: \(sqlStr)", errCode: status, errMsg: nil)
            return false
        }
        
        return true
    }
    
    public func close() {
        
        if pStmt == nil {
            return
        }
        
        sqlite3_finalize(pStmt)
        pStmt = nil
        database?.closeCursor(cursor: self)
        database = nil
    }
    
    
    
    
    
    
    private func columnIndexForName(name: String) -> Int32 {

        if let val = columnNames[name] {
            return val
        }

        return -1
    }
    
    public func intForColumn(name: String) -> Int? {
        return intForColumnIndex(index: columnIndexForName(name))
    }
    public func int32ForColumn(name: String) -> Int32? {
        return int32ForColumnIndex(index: columnIndexForName(name))
    }
    public func int64ForColumn(name: String) -> Int64? {
        return int64ForColumnIndex(index: columnIndexForName(name))
    }
    public func doubleForColumn(name: String) -> Double? {
        return doubleForColumnIndex(index: columnIndexForName(name))
    }
    public func stringForColumn(name: String) -> String? {
        return stringForColumnIndex(index: columnIndexForName(name))
    }
    public func boolForColumn(name: String) -> Bool? {
        return boolForColumnIndex(index: columnIndexForName(name))
    }
    public func dateForColumn(name: String) -> NSDate? {
        return dateForColumnIndex(index: columnIndexForName(name))
    }
    public func dataForColumn(name: String) -> NSData? {
        return dataForColumnIndex(index: columnIndexForName(name))
    }
    
    public func intForColumnIndex(index: Int32) -> Int? {
        if index < 0 || sqlite3_column_type(pStmt, index) == SQLITE_NULL {
            return nil
        }
        return Int(sqlite3_column_int64(pStmt, index))
    }
    public func int32ForColumnIndex(index: Int32) -> Int32? {
        if index < 0 || sqlite3_column_type(pStmt, index) == SQLITE_NULL {
            return nil
        }
        return sqlite3_column_int(pStmt, index)
    }
    public func int64ForColumnIndex(index: Int32) -> Int64? {
        if index < 0 || sqlite3_column_type(pStmt, index) == SQLITE_NULL {
            return nil
        }
        return Int64(sqlite3_column_int64(pStmt, index))
    }
    public func doubleForColumnIndex(index: Int32) -> Double? {
        if index < 0 || sqlite3_column_type(pStmt, index) == SQLITE_NULL {
            return nil
        }
        return sqlite3_column_double(pStmt, index)
    }
    public func stringForColumnIndex(index: Int32) -> String? {
        if index < 0 || sqlite3_column_type(pStmt, index) == SQLITE_NULL {
            return nil
        }
        UnsafePointer.
        let text = UnsafePointer<Int8>(sqlite3_column_text(pStmt, index))
        return String.init(describing: (text!))
    }
    public func boolForColumnIndex(index: Int32) -> Bool? {
        if index < 0 || sqlite3_column_type(pStmt, index) == SQLITE_NULL {
            return nil
        }
        let val = sqlite3_column_int(pStmt, index)
        if val == 0 {
            return false
        }
        return true
    }
    public func dateForColumnIndex(index: Int32) -> NSDate? {
        if index < 0 || sqlite3_column_type(pStmt, index) == SQLITE_NULL {
            return nil
        }
        return NSDate(timeIntervalSince1970: sqlite3_column_double(pStmt, index))
    }
    public func dataForColumnIndex(index: Int32) -> NSData? {
        if index < 0 || sqlite3_column_type(pStmt, index) == SQLITE_NULL {
            return nil
        }
        let dataSize = Int(sqlite3_column_bytes(pStmt, index))
        let blob = sqlite3_column_blob(pStmt, index)
        if blob == nil {
            return nil
        }
        return NSData(bytes: blob, length: dataSize)
    }
    
}
