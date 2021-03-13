//
//  EnviromentButton.swift
//  Base
//
//  Created by yleson on 2021/2/24.
//  环境切换

import Foundation

public class EnvironmentButton: UIButton {
    required init?(coder: NSCoder) {
        fatalError()
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: App.kScreenW - 40, y: App.kScreenH - 200, width: 40, height: 40))
        self.setTitle("环境", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.backgroundColor = UIColor.tools.hex(color: "#333333")
        self.layer.cornerRadius = 20.0
        self.addTarget(self, action: #selector(changeDidClick), for: .touchUpInside)
        // 创建手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragAction(gesture:)))
        self.addGestureRecognizer(pan)
    }
    
    // 点击切换
    @objc public func changeDidClick() {
        guard let from = UIApplication.shared.keyWindow?.rootViewController else {return}
        Environment.shared.changeEnvironment(from: from)
    }
    
    @objc public func dragAction(gesture: UIPanGestureRecognizer) {
        // 移动状态
        let moveState = gesture.state
        guard let view = UIApplication.shared.keyWindow?.rootViewController?.view else {return}
        switch moveState {
            case .began:
                break
            case .changed:
                // floatBtn 获取移动轨迹
                let point = gesture.translation(in: view)
                self.center = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
                break
            case .ended:
                // floatBtn 移动结束吸边
                let point = gesture.translation(in: view)
                var newPoint = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
                if newPoint.x < view.bounds.width / 2.0 {
                    newPoint.x = 20.0
                } else {
                    newPoint.x = view.bounds.width - 20.0
                }
                if newPoint.y <= 40.0 {
                    newPoint.y = 40.0
                } else if newPoint.y >= view.bounds.height - 40.0 {
                    newPoint.y = view.bounds.height - 40.0
                }
                // 0.5秒 吸边动画
                UIView.animate(withDuration: 0.5) {
                    self.center = newPoint
                }
                break
            default:
                break
        }
        // 重置 panGesture
        gesture.setTranslation(.zero, in: view)
    }
}
