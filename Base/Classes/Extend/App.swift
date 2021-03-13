//
//  App.swift
//  Base
//
//  Created by yleson on 2021/3/4.
//  全局

import UIKit

public struct App {
    /// 屏幕宽度
    public static let kScreenW = UIScreen.main.bounds.width
    
    /// 屏幕高度
    public static let kScreenH = UIScreen.main.bounds.height
    
    /// 导航栏高度
    public static let kNavigationBarH = UIApplication.shared.statusBarFrame.size.height + 44
    
    /// 屏幕分辨率倍数
    public static let kScreenScale = UIScreen.main.scale
    
    /// App名称
    public static var displayName: String {
        return (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String) ?? ""
    }
    
    /// BundleId
    public static var bundleId: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    /// 版本号
    public static var version: String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
    }
    
    /// 内部构建号
    public static var build: String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? "1"
    }
    
    /// 设备名称
    public static var deviceName: String {
        return UIDevice.current.localizedModel
    }
    
    /// 当前系统版本
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// 当前主窗口
    public static var keyWindow: UIView? {
        return UIApplication.shared.keyWindow
    }
    
}


/// 打印日志
public func print<T>(log: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
    let file = (file as NSString).lastPathComponent
    print("\n[\(file)]_[\(method)]_[行: \(line)]:\n\(log)\n")
    #endif
}
