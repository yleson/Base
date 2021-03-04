//
//  RouterProvider.swift
//  Base
//
//  Created by yleson on 2021/3/5.
//

import UIKit
import SwiftMediator

public typealias Complated = ([String : Any]) -> Void

public protocol RouterProviderType: AnyObject {
    associatedtype Target: ControllerConvertible
    func jump(from source: UIViewController?, to router: Target, with parameters: [String : Any], callBack handler: @escaping Complated, transition: ((UIViewController, UIViewController) -> Void)?)
}

public class RouterProvider<target: ControllerConvertible>: RouterProviderType {
    public let callback = "RouterProvider.callback"
    public init() {}
    public func jump(from source: UIViewController? = UIViewController.topWindowController(),
                     to router: target,
                     with parameters: [String : Any] = [:],
                     callBack handler: @escaping Complated = { _ in },
                     transition: ((UIViewController, UIViewController) -> Void)? = nil) {
        // 实例化目标对象
        let viewController = router.target.init()
        
        // 需要进行登录拦截
        if let intercept = router.intercept, intercept {
            if let result = (viewController as? ViewControllerIntercept)?.loginIntercept(), result {
                // 未登录直接返回
                return
            }
        }
        
        // 需要进行自定义拦截
        if let customIntercept = router.customIntercept, customIntercept {
            if let result = (viewController as? ViewControllerIntercept)?.customIntercept(), result {
                // 不满足条件，拦截返回
                return
            }
        }
        
        // 设置目标对象title
        if let title = router.title {
            viewController.title = title
        }
        
        // 配置目标对象需要参数
        if parameters.count > 0 {
            for (key, value) in parameters {
                viewController.putExtra(key, value)
            }
        }
        
        // 配置回调闭包
        viewController.putExtra(callback, handler)
        
        // 获取当前对象
        guard let windowController = source else {return}
        
        // 跳转逻辑
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let transition = transition {
                transition(viewController, windowController)
            } else {
                switch router.method {
                case .push:
                    guard let nav = windowController.navigationController else {
                        return
                    }
                    nav.pushViewController(viewController, animated: true)
                case .present(let parent):
                    guard let parent = parent else {
                        viewController.modalTransitionStyle = .crossDissolve
                        viewController.modalPresentationStyle = .fullScreen
                        windowController.present(viewController, animated: true)
                        return
                    }
                    let nav = parent.init(rootViewController: viewController)
                    nav.modalPresentationStyle = .fullScreen
                    windowController.present(nav, animated: true)
                }
            }
        }
    }
}



public extension UIViewController {
    class func getCurrentWindow() -> UIWindow? {
        var window: UIWindow? = UIApplication.shared.keyWindow
        if let w = window, w.windowLevel != UIWindow.Level.normal {
            for tempWindow in UIApplication.shared.windows {
                if tempWindow.windowLevel == UIWindow.Level.normal  {
                    window = tempWindow
                    break
                }
            }
        }
        return window
    }
    
    // MARK: 获取当前window上controller
    private class func getTopWindowController(_ viewController: UIViewController?) -> UIViewController? {
        guard let controller = viewController else {
            return nil
        }
        if let VC = controller.presentedViewController {
            return getTopWindowController(VC)
        }
        if controller.isKind(of: UISplitViewController.self) {
            let VC = controller as! UISplitViewController
            if VC.viewControllers.count > 0 {
                return getTopWindowController(VC.viewControllers.last)
            }
            return VC
        }
        if controller.isKind(of: UINavigationController.self) {
            let VC = controller as! UINavigationController
            if VC.viewControllers.count > 0 {
                return getTopWindowController(VC.topViewController)
            }
            return VC
        }
        if controller.isKind(of: UITabBarController.self) {
            let VC = controller as! UITabBarController
            guard let controllers = VC.viewControllers, controllers.count > 0 else {
                return VC
            }
            return getTopWindowController(VC.selectedViewController)
        }
        return controller
    }
    
    class func topWindowController() -> UIViewController? {
        guard let window = UIViewController.getCurrentWindow() else {
            return nil
        }
        return getTopWindowController(window.rootViewController!)
    }
}
