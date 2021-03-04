//
//  AppRouter.swift
//  Base_Example
//
//  Created by yleson on 2021/3/4.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Base


extension UIViewController: ViewControllerIntercept {
    
    public func loginIntercept() -> Bool {
        let isLogin: Bool = false
        if !isLogin {
            print("需要处理登录")
        }
        return !isLogin
    }
    
    public func customIntercept() -> Bool {
        print("自定义拦截")
        return true
    }
    
}
