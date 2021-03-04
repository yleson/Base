//
//  Router.swift
//  Base
//
//  Created by yleson on 2021/3/5.
//

import UIKit

/// 跳转方式
public enum ControllerOperation {
    case push
    case present(parent: UINavigationController.Type?)
}

/// 待跳转 controller 信息协议
public protocol ControllerConvertible {
    // 包名
    var namespace: String? {get}
    // 目标类
    var target: UIViewController.Type {get}
    // 跳转方法
    var method: ControllerOperation {get}
    // 目标类标题
    var title: String? {get}
    // 跳转是否需要进行登录拦截
    var intercept: Bool? {get}
    // 跳转是否需要进行自定义拦截
    var customIntercept: Bool? {get}
}


/// 页面路由传参
public protocol ViewControllerIntent {
    func putExtra<T>(_ key: String, _ value: T)
    func getExtra<T>(_ key: String) -> T?
}

extension UIViewController: ViewControllerIntent {
    
    // 扩展一个字典用于传参
    private struct intentStorage {
        static var extra: [String : Any] = [:]
    }
    
    public func putExtra<T>(_ key: String, _ value: T) {
        intentStorage.extra[key] = value
    }
    
    public func getExtra<T>(_ key: String) -> T? {
        return intentStorage.extra[key] as? T
    }
    
}


/// 页面拦截
@objc public protocol ViewControllerIntercept {
    // 登录拦截
    @objc func loginIntercept() -> Bool
    // 自定义拦截
    @objc func customIntercept() -> Bool
}

extension ViewControllerIntercept {
    func loginIntercept() -> Bool {
        print("登录拦截")
        return true
    }
    
    func customIntercept() -> Bool {
        print("自定义拦截")
        return true
    }
}
