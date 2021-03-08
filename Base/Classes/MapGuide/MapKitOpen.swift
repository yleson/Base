//
//  MapKitOpen.swift
//  Base
//
//  Created by yleson on 2021/3/8.
//

import Foundation
import MapKit

//检测地图是否存在然后打开
public struct MapKitOpen {
    
    /// 详细地址转经纬度
    public static func geocoderFromAddress(address: String, success: @escaping (Double, Double) -> Void) {
        // 创建一个会话，这个会话可以复用
        let session = URLSession(configuration: .default)
        // 设置URL
        guard let url = "https://apis.map.qq.com/ws/geocoder/v1/?address=\(address)&key=EWSBZ-6XR6K-EXOJN-A25WF-CQP76-WTF3C".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        let request = URLRequest(url: URL(string: url)!)
        // 创建一个网络任务
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                guard let data = data else {return}
                guard let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                if let result = response["result"] as? [String: Any], result.keys.contains("location"), let location = result["location"] as? [String: Any], let latitude = location["lat"] as? Double, let longitude = location["lng"] as? Double {
                    success(latitude, longitude)
                }
            } catch {
                print("无法连接到服务器")
                return
            }
        }
        // 运行此任务
        task.resume()
    }
    
    
    /// 打开地图
    public static func checkMapAppInPhoneAndJumpInto(targetLat: Double, targetLong: Double, targetName: String, VC: UIViewController) {
        //盛放地图元素的数组
        var maps = [[String: String]]()
        //判断地图
        //苹果地图
        if UIApplication.shared.canOpenURL(URL(string: MapKitType.MapKitUri.apple.rawValue)!) {
            var iosMap = [String: String]()
            iosMap["title"] = MapKitType.MapKitName.apple.rawValue
            maps.append(iosMap)
        }
        //百度地图
        if UIApplication.shared.canOpenURL(URL(string: MapKitType.MapKitUri.baidu.rawValue)!) {
            var baiduDic = [String: String]()
            baiduDic["title"] = MapKitType.MapKitName.baidu.rawValue
            let urlString = MapKitPath.baidu(targetLat: targetLat, targetLon: targetLong, targetName: targetName)
            baiduDic["url"] = urlString
            maps.append(baiduDic)
        }
        //高德地图
        if UIApplication.shared.canOpenURL(URL(string: MapKitType.MapKitUri.gaode.rawValue)!) {
            var gaodeDic = [String: String]()
            gaodeDic["title"] = MapKitType.MapKitName.gaode.rawValue
            let urlString = MapKitPath.gaode(targetLat: targetLat, targetLon: targetLong, targetName: targetName)
            let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            gaodeDic["url"] = escapedString
            maps.append(gaodeDic)
        }
        //腾讯地图
        if UIApplication.shared.canOpenURL(URL(string: MapKitType.MapKitUri.tencent.rawValue)!) {
            var qqDic = [String: String]()
            qqDic["title"] = MapKitType.MapKitName.tencent.rawValue
            let urlString = MapKitPath.tencent(targetLat: targetLat, targetLon: targetLong, targetName: targetName)
            let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            qqDic["url"] = escapedString
            maps.append(qqDic)
        }
        if maps.count == 0 {
            return
        }
        let alertVC = UIAlertController.init(title: "请选择导航应用程序", message: nil, preferredStyle: .actionSheet)
        for i in 0..<maps.count {
            let title = maps[i]["title"]
            let action = UIAlertAction(title: title, style: .default) { (_) in
                if i == 0 {
                    let loc = CLLocationCoordinate2DMake(targetLat, targetLong)
                    let currentLocation = MKMapItem.forCurrentLocation()
                    let toLocation = MKMapItem(placemark: MKPlacemark(coordinate: loc, addressDictionary: nil))
                    toLocation.name = targetName
                    MKMapItem.openMaps(with: [currentLocation, toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true])
                } else {
                    let urlString = maps[i]["url"]! as NSString
                    let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                    UIApplication.shared.open(url! as URL, options: [:]) { result in
                        print("result: \(result)")
                    }
                }
            }
            alertVC.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        VC.present(alertVC, animated: true, completion: nil)
    }
}

