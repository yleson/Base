//
//  UserDefaultsCache.swift
//  Base
//
//  Created by yleson on 2021/2/23.
//  本地存储

import Foundation

extension UserDefaults {
    public struct Name: RawRepresentable, Equatable {
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    public func object(forName name: UserDefaults.Name) -> Any? {
        return object(forKey: name.rawValue)
    }

    public func set(_ value: Any?, forName name: UserDefaults.Name) {
        set(value, forKey: name.rawValue)
    }
    
    public func removeObject(forName name: UserDefaults.Name) {
        removeObject(forKey: name.rawValue)
    }
    
    public func string(forName name: UserDefaults.Name) -> String? {
        return string(forKey: name.rawValue)
    }
        
    public func string(forName name: UserDefaults.Name, defaultValue: String) -> String {
        return string(forKey: name.rawValue) ?? defaultValue
    }
        
    public func array(forName name: UserDefaults.Name) -> [Any]? {
        return array(forKey: name.rawValue)
    }
        
    public func array(forName name: UserDefaults.Name, defaultValue: [Any]) -> [Any] {
        return array(forKey: name.rawValue) ?? defaultValue
    }
        
    public func dictionary(forName name: UserDefaults.Name) -> [String: Any]? {
        return dictionary(forKey: name.rawValue)
    }
        
    public func dictionary(forName name: UserDefaults.Name, defaultValue: [String: Any]) -> [String: Any] {
        return dictionary(forKey: name.rawValue) ?? defaultValue
    }
    
    public func data(forName name: UserDefaults.Name) -> Data? {
        return data(forKey: name.rawValue)
    }
        
    public func data(forName name: UserDefaults.Name, defaultValue: Data) -> Data {
        return data(forKey: name.rawValue) ?? defaultValue
    }
        
    public func stringArray(forName name: UserDefaults.Name) -> [String]? {
        return stringArray(forKey: name.rawValue)
    }
        
    public func stringArray(forName name: UserDefaults.Name, defaultValue: [String]) -> [String] {
        return stringArray(forKey: name.rawValue) ?? defaultValue
    }
        
    public func url(forName name: UserDefaults.Name) -> URL? {
        return url(forKey: name.rawValue)
    }
        
    public func url(forName name: UserDefaults.Name, defaultValue: URL) -> URL {
        return url(forKey: name.rawValue) ?? defaultValue
    }
        
    public func set(_ url: URL?, forName name: UserDefaults.Name) {
        set(url, forKey: name.rawValue)
    }
        
    public func integer(forName name: UserDefaults.Name) -> Int {
        return integer(forKey: name.rawValue)
    }
        
    public func float(forName name: UserDefaults.Name) -> Float {
        return float(forKey: name.rawValue)
    }
        
    public func double(forName name: UserDefaults.Name) -> Double {
        return double(forKey: name.rawValue)
    }
        
    public func bool(forName name: UserDefaults.Name) -> Bool {
        return bool(forKey: name.rawValue)
    }
        
    public func set(_ value: Int, forName name: UserDefaults.Name) {
        set(value, forKey: name.rawValue)
    }
        
    public func set(_ value: Float, forName name: UserDefaults.Name) {
        set(value, forKey: name.rawValue)
    }

    public func set(_ value: Double, forName name: UserDefaults.Name) {
        set(value, forKey: name.rawValue)
    }

    public func set(_ value: Bool, forName name: UserDefaults.Name) {
        set(value, forKey: name.rawValue)
    }
}

// MARK: - 扩展支持传入字符串赋值
extension UserDefaults.Name: ExpressibleByStringLiteral {
    public typealias UnicodeScalarLiteralType = String
    public typealias ExtendedGraphemeClusterLiteralType = String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

// MARK: - 提供常用Key
extension UserDefaults.Name {
    /// 是否第一次启动
    public static let isFirst: UserDefaults.Name = "isFirst"
    /// 当前语言
    public static let language: UserDefaults.Name = "language"
}
