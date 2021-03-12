//
//  ViewController.swift
//  Base
//
//  Created by huangshuoxing on 2021/3/4.
//  Copyright (c) 2021 huangshuoxing. All rights reserved.
//

import UIKit
import Base

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("13726224442".tools.isPhoneNumber)
        print("541243".tools.isPurnInt)
        print("15m12n412".tools.subString(2))
        
        
        print(UIDevice.tools.windowArea)
        
        
        print(self.view.tools.width)
        
        
        print(Date().tools.dayInWeek)
        
        var button = UIButton(title: "123", color: UIColor.tools.hex(color: "#000000"), font: nil, cornerRadius: 2)
        button.tools.title = "345"
//        button.tools
        
        print(App.kScreenW)
        
        print(UserDefaults.standard.string(forName: UserDefaults.Name.isFirst))
        print(UserDefaults.standard.string(forName: UserDefaults.Name.userId))
        
//        let router = Router(rawValue: "ExampleController")
//        print(router)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Page.jump(to: Router.Example)
        MapKitOpen.checkMapAppInPhoneAndJumpInto(targetLat: 23.4221, targetLong: 124.12314, targetName: "标题", VC: self)
    }

}



//extension UIViewController: ViewControllerIntent {
//
//}

extension UserDefaults.Name {
    static let userId: UserDefaults.Name = "userId"
}
