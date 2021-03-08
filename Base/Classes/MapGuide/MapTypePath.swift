//
//  MapTypePath.swift
//  Base
//
//  Created by yleson on 2021/3/8.
//

import Foundation

enum MapKitType {
    enum MapKitUri: String {
        // 高德
        case gaode = "iosamap://"
        // 百度
        case baidu = "baidumap://"
        // 腾讯
        case tencent = "qqmap://"
        // 苹果自带
        case apple = "http://maps.apple.com/"
    }
    
    enum MapKitName: String {
        // 高德
        case gaode = "高德地图"
        // 百度
        case baidu = "百度地图"
        // 腾讯
        case tencent = "腾讯地图"
        // 苹果自带
        case apple = "苹果地图"
    }
}




struct MapKitPath {
    static func baidu(targetLat:Double, targetLon:Double, targetName:String) -> String {
        return "baidumap://map/direction?origin={{我的位置}}&destination=name:\(targetName)|latlng:\(targetLat),\(targetLon)&mode=driving&src=\(targetName)&coord_type=gcj02"
    }
    static func gaode(targetLat:Double, targetLon:Double, targetName:String) -> String {
        return "iosamap://path?sourceApplication=导航功能&backScheme=lookcat&poiname=\(targetName)&poiid=BGVIS&lat=\(targetLat)&lon=\(targetLon)&dname=\(targetName)&dev=0&m=0"
    }
    static func tencent(targetLat:Double, targetLon:Double, targetName:String) -> String {
        return "qqmap://routeplan?type=bus&from=&fromcoord=&to=\(targetName)&tocoord=\(targetLat),\(targetLon)&policy=1&referer=看猫"
    }
}
