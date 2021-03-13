//
//  Enviroment.swift
//  Base
//
//  Created by yleson on 2021/2/24.
//  环境切换

import Foundation


public class Environment: NSObject {
    public enum EnvironmentType: String {
        case dev
        case prod
    }
    public enum EnvironmentTarget: String {
        case kDebug
        case kInternal
        case kRelease
        case kAppstore
    }
    
    /// 默认DEBUG
    public var target: EnvironmentTarget = .kDebug
    
    /// 单例
    public static let shared = Environment()
    private override init() {}
    
    // 启用
    public func start(target: EnvironmentTarget = .kDebug) {
        self.target = target
        guard target == .kInternal else {return}
        guard let from = UIApplication.shared.keyWindow?.rootViewController else {return}
        from.view.addSubview(EnvironmentButton())
    }
    
    // 当前获取当前环境
    public func currentEnvironment() -> EnvironmentType {
        var current: EnvironmentType = .prod
        if self.target == .kDebug {
            current = .dev
        } else if self.target == .kInternal {
            if let type = UserDefaults.standard.object(forKey: "EnvironmentType") as? String {
                current = Environment.EnvironmentType(rawValue: type) ?? .dev
            } else {
                current = .dev
            }
        }
        return current
    }
    
    // 设置环境
    public func changeEnvironment(from: UIViewController, callback: (() -> Void)? = nil) {
        let alertVC = UIAlertController.init(title: "切换环境", message: "切换环境后请手动重新启动APP", preferredStyle: .actionSheet)
        if self.currentEnvironment() == .dev {
            let action = UIAlertAction(title: "线上环境", style: .default) { (_) in
                UserDefaults.standard.set(Environment.EnvironmentType.prod.rawValue, forKey: "EnvironmentType")
                UserDefaults.standard.synchronize()
                callback?()
                abort()
            }
            alertVC.addAction(action)
        } else {
            let action = UIAlertAction(title: "测试环境", style: .default) { (_) in
                UserDefaults.standard.set(Environment.EnvironmentType.dev.rawValue, forKey: "EnvironmentType")
                UserDefaults.standard.synchronize()
                callback?()
                abort()
            }
            alertVC.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        from.present(alertVC, animated: true, completion: nil)
    }
}
