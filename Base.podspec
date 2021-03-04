#
# Be sure to run `pod lib lint Base.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Base'
  s.version          = '0.1.0'
  s.summary          = '基础开发库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/huangshuoxing/Base'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huangshuoxing' => 'yleson@besteam.cn' }
  s.source           = { :git => 'https://github.com/huangshuoxing/Base.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  
  s.source_files = 'Base/Classes/**/*'
  s.resources = ['Base/Assets/*']
  
  # 组件化通讯
  s.dependency 'SwiftMediator'
  # 数据库
  s.dependency 'WCDB.swift'
  # 网络请求
  s.dependency 'Moya', '14.0.0'
  # 模型解析
  s.dependency 'HandyJSON', '5.0.2'
  # 图片加载
  s.dependency 'Kingfisher', '6.1.1'
  # 上下拉刷新
  s.dependency 'MJRefresh', '3.5.0'
  # 自动布局
  s.dependency 'SnapKit', '5.0.1'
  # 空白占位图
  s.dependency 'DZNEmptyDataSet', '1.8.1'
  # Toast
  s.dependency 'SVProgressHUD', '2.2.5'
  # Loading
  s.dependency 'NVActivityIndicatorView', '5.1.1'
  # 键盘管理
  s.dependency 'IQKeyboardManagerSwift', '6.3.0'
  # 选择器
  s.dependency 'BRPickerView', '2.7.3'
  # 第三方通讯
  s.dependency 'MonkeyKing', '2.1.0'
  # 弹窗
  s.dependency 'Presentr', '1.9'
  # 大图查看器
  s.dependency 'Lantern', '1.1.2'
  # 图片选择器
  s.dependency 'ZLPhotoBrowser', '4.1.7'
  
  
end
