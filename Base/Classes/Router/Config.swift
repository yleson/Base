//
//  Config.swift
//  Base
//
//  Created by yleson on 2021/3/5.
//

import Foundation

/// 跳转发起
public let Page = RouterProvider<Router>()

/// 跳转控制路由，在这里添加要跳转页面
public enum Router: String {
    // MARK: - 例子
    case Example = "ExampleController"
}

extension Router: ControllerConvertible {
    
    // 包名
    public var namespace: String? {
        switch self {
        case .Example:
            return "Base"
        default:
            return Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
        }
    }
    
    // 目标类
    public var target: UIViewController.Type {
        switch self {
        default:
            if var namespace = self.namespace {
                namespace = namespace.replacingOccurrences(of: "-", with: "_")
                let className = "\(namespace).\(self.rawValue)"
                let cls: AnyClass? = NSClassFromString(className)
                if let vc = cls as? UIViewController.Type {
                    return vc
                }
            }
            return UIViewController.self
        }
    }
    
    // 跳转方法
    public var method: ControllerOperation {
        
        switch self {
        case .Example:
            return .present(parent: nil)
        default:
            return .push
        }
        
    }
    
    // 目标类标题
    public var title: String? {
        switch self {
        case .Example:
            return "示例"
            
        default:
            return ""
        }
    }
    
    // 跳转是否进行登录拦截
    public var intercept: Bool? {
        switch self {
        case .Example:
            return true
        default:
            return true
        }
    }
    
    // 跳转是否需要进行自定义拦截
    public var customIntercept: Bool? {
        switch self {
        case .Example:
            return true
        default:
            return false
        }
    }
}





// MARK: - 示例控制器
class ExampleController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("进入示例控制器")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("离开示例控制器")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
//    override func loginIntercept() {
//        <#code#>
//    }
}
