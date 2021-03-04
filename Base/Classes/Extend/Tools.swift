//
//  Tools.swift
//  Base
//
//  Created by yleson on 2021/3/4.
//  工具

import Foundation
import UIKit

public struct Tools<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

// 协议扩展属性
public protocol ToolsPrefix {}
public extension ToolsPrefix {
    // 类成员变量
    static var tools: Tools<Self>.Type {
        set {}
        get {
            return Tools<Self>.self
        }
    }
    // 实例成员变量
    var tools: Tools<Self> {
        set {}
        get {
            return Tools(self)
        }
    }
}






// --------------- Foundation -----------------
// MARK: - 扩展String
extension String: ToolsPrefix {}
public extension Tools where Base == String {
    /// 是否是空串，包含全是空格
    var isBlank: Bool {
        return base.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// 手机号简单检验，1开头且11位数
    var isPhoneNumber: Bool {
        let mobileReg = "^1\\d{10}$"
        return NSPredicate(format: "SELF MATCHES %@", mobileReg).evaluate(with: base)
    }
    
    /// 判断输入的字符串是否为数字，不含其它字符
    var isPurnInt: Bool {
        let scan: Scanner = Scanner(string: base)
        var val: Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    /// Base64编码
    var encodeBase64: String {
        guard let data = base.data(using: .utf8) else {
            return ""
        }
        return data.base64EncodedString()
    }
    
    /// Base64解码
    var decodeBase64: String {
        guard let data = Data(base64Encoded: base), let text = String(data: data, encoding: .utf8) else {
            return ""
        }
        return text
    }
    
    /// URL参数编码
    var encodeURIComponent: String {
        let set = NSMutableCharacterSet()
        set.formUnion(with: NSMutableCharacterSet.alphanumeric() as CharacterSet)
        set.formUnion(with: NSMutableCharacterSet(charactersIn:"-_.!~*'()") as CharacterSet)
        guard let ret = base.addingPercentEncoding(withAllowedCharacters: set as CharacterSet) else {
            return ""
        }
        return ret
    }
    
    /// Unicode解码
    var deocdeUnicode: String {
        let tempStr1 = base.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr: String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
            return returnStr
        } catch {
            
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
    
    /// 截取字符串: index 开始到结尾
    /// - Parameter index: 开始截取的index
    /// - Returns: string
    func subString(_ index: Int) -> String {
        guard index < base.count else {
            return ""
        }
        let start = base.index(base.endIndex, offsetBy: index - base.count)
        return String(base[start..<base.endIndex])
    }
    
    /// 截取字符串
    /// - Parameters:
    ///   - begin: 开始截取的索引
    ///   - count: 需要截取的个数
    /// - Returns: 字符串
    func substring(start: Int, _ count: Int) -> String {
        let begin = base.index(base.startIndex, offsetBy: max(0, start))
        let end = base.index(base.startIndex, offsetBy: min(count, start + count))
        return String(base[begin..<end])
    }
}



// MARK: - 扩展Date
extension Date: ToolsPrefix {}
public extension Tools where Base == Date {
    /// 日期是否是今天
    var isToday: Bool {
        return self.isSameDay(diff: Date())
    }
    
    /// 日期是否是昨天
    var isYesterday: Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.day], from: Date())
        let selfComponents = calendar.dateComponents([.day], from: base as Date)
        let cmps = calendar.dateComponents([.day], from: selfComponents, to: nowComponents)
        return cmps.day == 1
    }
    
    /// 日期是否在本周
    var isNowWeek: Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.day,.month,.year], from: Date())
        let selfComponents = calendar.dateComponents([.weekday,.month,.year], from: base as Date)
        return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month) && (selfComponents.weekday == nowComponents.weekday)
    }
    
    /// 日期是否在本年
    var isNowYear: Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.day,.month,.year], from: Date())
        let selfComponents = calendar.dateComponents([.weekday,.month,.year], from: base as Date)
        return (selfComponents.year == nowComponents.year)
    }
    
    /// 返回今天星期几
    var dayInWeek: String {
        let weekdays:NSArray = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar.init(identifier: .gregorian)
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: base as Date)
        return weekdays.object(at: theComponents.weekday! - 1) as? String ?? ""
    }
    
    /// 返回今天是几月份
    var monthInYear: String {
        let months: NSArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var calendar = Calendar.init(identifier: .gregorian)
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.month], from: base as Date)
        return months.object(at: theComponents.month! - 1) as! String
    }
    
    /// 比较两个日期是否是同一天
    func isSameDay(diff: Date) -> Bool {
        let calendar = Calendar.current
        let diffComponents = calendar.dateComponents([.day,.month,.year], from: diff)
        let selfComponents = calendar.dateComponents([.weekday,.month,.year], from: base as Date)
        return (selfComponents.year == diffComponents.year) && (selfComponents.month == diffComponents.month) && (selfComponents.day == diffComponents.day)
    }
    
    /// 日期根据formatter转字符串
    func dateStringFromFormatter(dateFormat: String = "yyyy年MM月dd日 HH时mm分ss秒") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: base)
    }
    
    /// 日期根据dateStyle或timeStyle属性转换
    func dateStringFromStyle(dateStyle: DateFormatter.Style = .none, timeStyle: DateFormatter.Style = .none) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.locale = Locale(identifier: "zh_CN")
        return dateFormatter.string(from: base)
    }
    
    /// 字符串根据formatter转日期
    static func dateFromDateString(_ string: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: string) else {
            return Date()
        }
        return date
    }
    
    /// 时间戳转时间函数
    static func timeStampToString(timeStamp: Double, outputFormatter: String) -> String {
        // 时间戳为毫秒级要／1000 (13位数)，秒就不用除1000（10位数），参数带没带000
        let timeString = String.init(format: "%d", timeStamp)
        let timeSta: TimeInterval
        if timeString.count == 10 {
            timeSta = TimeInterval(timeStamp)
        } else {
            timeSta = TimeInterval(timeStamp / 1000)
        }
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        // 设定时间格式,这里可以设置成自己需要的格式yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat = outputFormatter
        return dfmatter.string(from: date as Date)
    }

    /// 时间转时间戳函数
    static func timeToTimeStamp(time: String, inputFormatter: String) -> Double {
        let dfmatter = DateFormatter()
        // 设定时间格式,这里可以设置成自己需要的格式
        dfmatter.dateFormat = inputFormatter
        let last = dfmatter.date(from: time)
        let timeStamp = last?.timeIntervalSince1970
        return timeStamp ?? 0
    }
    
    /// 根据后台时间戳返回几分钟前，几小时前，几天前
    static func updateTimeToCurrentTime(timeStamp: Double, inputFormatter: String = "yyyy年MM月dd日 HH:mm:ss") -> String {
        // 获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        // 时间戳为毫秒级要／1000，秒就不用除1000，参数带没带000
        let timeSta: TimeInterval = TimeInterval(timeStamp > 9999999999 ? (timeStamp / 1000) : timeStamp)
        // 时间差
        let reduceTime : TimeInterval = currentTime - timeSta
        // 时间差小于60秒
        if reduceTime < 60 {
            return "刚刚"
        }
        // 时间差大于一分钟小于60分钟内
        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }
        let days = Int(reduceTime / 3600 / 24)
        if days < 30 {
            return "\(days)天前"
        }
        // 不满足上述条件---或者是未来日期-----直接返回日期
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        // yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat = inputFormatter
        return dfmatter.string(from: date as Date)
    }
    
    /// 秒转dd/HH/mm/dd
    static func secondToEndTimeString(time: Int) -> String {
        let days = time / (24 * 3600)
        let hours = time % (24 * 3600) / 3600
        let minutes = time % 3600 / 60
        let seconds = time % 60
        var result = ""
        if days > 0 {
            result.append("\(String(format: "%02d", days))天")
        }
        if hours > 0 {
            result.append("\(String(format: "%02d", hours))时")
        }
        result.append("\(String(format: "%02d", minutes))分")
        result.append("\(String(format: "%02d", seconds))秒")
        return result
    }
    
    /// 秒转mm/dd
    static func secondToMSEndTimeString(time: Int) -> String {
        let minutes = time % (24 * 3600) / 60
        let seconds = time % 60
        var result = ""
        result.append("\(String(format: "%02d", minutes))分")
        result.append("\(String(format: "%02d", seconds))秒")
        return result
    }
    
    /// 秒转hh/mm/dd
    static func secondToHMSEndTimeString(time: Int) -> String {
        let hours = time % (24 * 3600) / 3600
        let minutes = time % 3600 / 60
        let seconds = time % 60
        var result = ""
        if hours > 0 {
            result.append("\(String(format: "%02d", hours))时")
        }
        result.append("\(String(format: "%02d", minutes))分")
        result.append("\(String(format: "%02d", seconds))秒")
        return result
    }
    
    /// 根据后台时间戳返回几分钟前，几小时前，几天前
    static func covertToMessageTime(timeStamp: Double) -> String {
        //获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(timeStamp > 9999999999 ? (timeStamp / 1000) : timeStamp)
        //如果服务端返回的时间戳精确到毫秒，需要除以1000,否则不需要
        let date = Date(timeIntervalSince1970: timeSta)
        
        let formatter = DateFormatter()
        if date.tools.isToday {
            // 是今天
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        } else if date.tools.isYesterday {
            // 是昨天
            formatter.dateFormat = "昨天HH:mm"
            return formatter.string(from: date)
        } else if date.tools.isNowWeek {
            // 是同一周
            formatter.dateFormat = "\(date.tools.dayInWeek)HH:mm"
            return formatter.string(from: date)
        } else if date.tools.isNowYear {
            // 是同一年
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.string(from: date)
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: date)
        }
    }
}



// MARK: - 扩展NSDecimalNumber
extension NSDecimalNumber: ToolsPrefix {}
public extension Tools where Base == NSDecimalNumber {
    /// 处理小数点
    func format(precision: Int? = nil) -> String {
        let doubleValue = Double(truncating: base as NSNumber)
        if let precision = precision {
            // 指定小数点位数
            return String(format: "%.\(precision)f", doubleValue)
        }
        if fmod(doubleValue, 1) == 0 {
            return String(format: "%.0f", doubleValue)
        } else if fmod(doubleValue * 10, 1) == 0 {
            return String(format: "%.1f", doubleValue)
        } else {
            return String(format: "%.2f", doubleValue)
        }
    }
}







// ---------------- UI --------------------
// MARK: - 扩展UIDevice
extension UIDevice: ToolsPrefix {}
public extension Tools where Base == UIDevice {
    /// 是否全面屏和安全区域
    static var windowArea: [Any] {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                  return [false, 0.0, 0.0, 0.0, 0.0]
              }
              
              if unwrapedWindow.safeAreaInsets.top > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                return [true, unwrapedWindow.safeAreaInsets.top, unwrapedWindow.safeAreaInsets.right, unwrapedWindow.safeAreaInsets.bottom, unwrapedWindow.safeAreaInsets.left]
              }
        }
        return [false, 0.0, 0.0, 0.0, 0.0]
    }
    
    /// 判断是否是全面屏
    static var isFullScreen: Bool {
        return self.windowArea[0] as? Bool ?? false
    }
    
    /// 顶部安全高度
    static var safeTopHeight: CGFloat {
        return self.windowArea[1] as? CGFloat ?? 0.0
    }
    
    /// 底部安全高度
    static var safeBottomHeight: CGFloat {
        return self.windowArea[3] as? CGFloat ?? 0.0
    }
    
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
}



// MARK: - 扩展UIView
public extension UIView {
    /// 处理圆角
    func cornerRadius(_ radius: CGFloat = 0) {
        guard radius > 0 else {return}
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}
extension UIView: ToolsPrefix {}
public extension Tools where Base == UIView {
    /// 横坐标
    var x: CGFloat {
        set(newValue) {
            var frame = base.frame
            frame.origin.x = newValue
            base.frame = frame
        }
        get { base.frame.minX }
    }
    
    /// 纵坐标
    var y: CGFloat {
        set(newValue) {
            var frame = base.frame
            frame.origin.y = newValue
            base.frame = frame
        }
        get { base.frame.minY }
    }
    
    /// 宽度
    var width: CGFloat {
        set(newValue) {
            var frame = base.frame
            frame.size.width = newValue
            base.frame = frame
        }
        get { base.frame.size.width }
    }
    
    /// 高度
    var height: CGFloat {
        set(newValue) {
            var frame = base.frame
            frame.size.height = newValue
            base.frame = frame
        }
        get { base.frame.size.height }
    }
}



// MARK: - 扩展UIButton
public extension UIButton {
    convenience init(title: String?, color: UIColor?, font: UIFont?, cornerRadius: CGFloat = 0) {
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.cornerRadius(cornerRadius)
    }
}
extension UIButton: ToolsPrefix {}
public extension Tools where Base == UIButton {
    /// 默认背景图片
    var backgroundImage: UIImage? {
        set(newValue) {
            base.setBackgroundImage(newValue, for: .normal)
        }
        get { base.backgroundImage(for: .normal) }
    }
    /// 选中图片
    var selectedBackgroundImage: UIImage? {
        set(newValue) {
            base.setBackgroundImage(newValue, for: .selected)
        }
        get { base.backgroundImage(for: .selected) }
    }
    /// 高亮图片
    var highlightBackgroundImage: UIImage? {
        set(newValue) {
            base.setBackgroundImage(newValue, for: .highlighted)
        }
        get { base.backgroundImage(for: .highlighted) }
    }
    /// 禁用图片
    var disabledBackgroundImage: UIImage? {
        set(newValue) {
            base.setBackgroundImage(newValue, for: .disabled)
        }
        get { base.backgroundImage(for: .disabled) }
    }
    
    /// 默认图片
    var image: UIImage? {
        set(newValue) {
            base.setImage(newValue, for: .normal)
        }
        get { base.image(for: .normal) }
    }
    /// 选中图片
    var selectedImage: UIImage? {
        set(newValue) {
            base.setImage(newValue, for: .selected)
        }
        get { base.image(for: .selected) }
    }
    /// 高亮图片
    var highlightImage: UIImage? {
        set(newValue) {
            base.setImage(newValue, for: .highlighted)
        }
        get { base.image(for: .highlighted) }
    }
    /// 禁用图片
    var disabledImage: UIImage? {
        set(newValue) {
            base.setImage(newValue, for: .disabled)
        }
        get { base.image(for: .disabled) }
    }
    
    /// 默认标题
    var title: String? {
        set(newValue) {
            base.setTitle(newValue, for: .normal)
        }
        get { base.title(for: .normal) ?? "" }
    }
    /// 选中标题
    var selectedTitle: String? {
        set(newValue) {
            base.setTitle(newValue, for: .selected)
        }
        get { base.title(for: .selected) ?? "" }
    }
    /// 高亮标题
    var highlightTitle: String? {
        set(newValue) {
            base.setTitle(newValue, for: .highlighted)
        }
        get { base.title(for: .highlighted) ?? "" }
    }
    /// 禁用标题
    var disabledTitle: String? {
        set(newValue) {
            base.setTitle(newValue, for: .disabled)
        }
        get { base.title(for: .disabled) ?? "" }
    }
    
    /// 默认颜色
    var titleColor: UIColor? {
        set(newValue) {
            base.setTitleColor(newValue, for: .normal)
        }
        get { base.titleColor(for: .normal) }
    }
    /// 选中标题
    var selectedTitleColor: UIColor? {
        set(newValue) {
            base.setTitleColor(newValue, for: .selected)
        }
        get { base.titleColor(for: .selected) }
    }
    /// 高亮标题
    var highlightTitleColor: UIColor? {
        set(newValue) {
            base.setTitleColor(newValue, for: .highlighted)
        }
        get { base.titleColor(for: .highlighted) }
    }
    /// 禁用标题
    var disabledTitleColor: UIColor? {
        set(newValue) {
            base.setTitleColor(newValue, for: .disabled)
        }
        get { base.titleColor(for: .disabled) }
    }
    
    /// 字体
    var font: UIFont? {
        set(newValue) {
            base.titleLabel?.font = newValue
        }
        get { base.titleLabel?.font }
    }
}



// MARK: - 扩展UIColor
extension UIColor: ToolsPrefix {}
public extension Tools where Base == UIColor {
    /// 随机颜色（给控件一个背景色，方便调试）
    var random: UIColor {
        let red = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255)) / CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
        let alpha = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
        return UIColor.init(red:red, green:green, blue:blue , alpha: alpha)
    }
    
    /// 16进制字符串rgba
    static func hex(color: String, alpha: CGFloat = 1.0) -> UIColor {
        let hexString = color.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// rgb
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, l: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: l)
    }
    
    /// 适配暗黑模式, 传入颜色16进制
    static func colors(light: String, dark: String) -> UIColor {
        return colors(light: hex(color: light), dark: hex(color: dark))
    }
    
    /// 适配暗黑模式, 传入颜色对象
    static func colors(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            let color = UIColor.init { (traitCollection) -> UIColor in
                if (traitCollection.userInterfaceStyle == .dark) {
                    return dark
                } else {
                    return light
                }
            }
            return color
        }
        return light
    }
}
