//
//  DatabaseCache.swift
//  Base
//
//  Created by yleson on 2021/2/23.
//  数据库

import Foundation
import WCDBSwift

public class DatabaseCache: NSObject {
    
    /// 单例
    public static let shared = DatabaseCache()
    /// 数据库
    private var dataBase: Database?
    
    
    private override init() {
        super.init()
        
        // 创建数据库
        self.createDatabase()
    }
    
    /// 创建db
    private func createDatabase() {
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbName = (rootPath.hasSuffix("/") ? "" : "/") + (Bundle.main.bundleIdentifier ?? "main")
        let dbPath = rootPath.appending(dbName)
        self.dataBase = Database(withFileURL: URL.init(fileURLWithPath: dbPath))
    }

    /// 创建表
    public func createTable<T: TableDecodable>(table: String, of type: T.Type) -> Void {
        do {
            try dataBase?.create(table: table, of: type)
        } catch {
            print(error.localizedDescription)
        }
    }

    /// 插入或更新
    public func insert<T: TableEncodable>(objects: [T], table: String) -> Void {
        do {
            /// 执行事务
            try dataBase?.run(transaction: {
                try dataBase?.insertOrReplace(objects: objects, intoTable: table)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    /// 插入或更新
    public func insertOrReplace<T: TableEncodable>(object: T, table: String) -> Void {
        do {
            /// 执行事务
            try dataBase?.run(transaction: {
                try dataBase?.insertOrReplace(objects: object, intoTable: table)
            })
        } catch {
            print(error.localizedDescription)
        }
    }

    /// 修改
    public func update<T: TableEncodable>(table: String, on propertys: [PropertyConvertible], with object: T, where condition: Condition? = nil) -> Void {
        do {
            try dataBase?.update(table: table, on: propertys, with: object, where: condition)
        } catch {
            print(error.localizedDescription)
        }
    }

    /// 删除
    public func delete(fromTable: String, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: WCDBSwift.Offset? = nil) {
        do {
            try dataBase?.run(transaction: {
                try dataBase?.delete(fromTable: fromTable, where: condition, orderBy: orderList, limit: limit, offset: offset)
            })
        } catch {
            print(error.localizedDescription)
        }
    }

    /// 查询
    public func qureys<T: TableDecodable>(fromTable: String, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where: condition, orderBy: orderList, limit: limit, offset: offset))!
            return allObjects
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    /// 查询单条数据
    public func qurey<T: TableDecodable>(fromTable: String, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil) -> T? {
        do {
            let object: T? = try (dataBase?.getObject(fromTable: fromTable, where: condition, orderBy: orderList))
            return object
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
