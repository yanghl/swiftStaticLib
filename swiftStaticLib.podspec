Pod::Spec.new do |s|
  s.name             = 'swiftStaticLib'
  s.version          = '0.1.0'
  s.summary          = 'A short description of swiftStaticLib.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/272789124@qq.com/swiftStaticLib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '272789124@qq.com' => 'yanghl01@beantechs.cn' }
  s.source           = { :git => 'https://github.com/272789124@qq.com/swiftStaticLib.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'
  s.source_files = 'swiftStaticLib/Classes/**/{*.swift,*.h,*.m}'
  s.resource_bundles = {
      'swiftStaticLib' => ['swiftStaticLib/Assets/**/{*}', 'swiftStaticLib/Classes/**/{*.storyboard,*.xib}']
    }
  s.static_framework = true


    s.dependency 'RxSwift'
    s.dependency 'RxCocoa'
    s.dependency 'SnapKit'
    s.dependency 'Kingfisher'
    s.dependency 'SwiftyUserDefaults'
    s.dependency 'NVActivityIndicatorView'
    s.dependency 'Toast-Swift'
    s.dependency 'Moya'
    s.dependency 'MoyaMapper'
    s.dependency 'MoyaMapper/MMCache'
    s.dependency 'SwiftyJSON'
    s.dependency 'R.swift'
    s.dependency 'KeychainAccess'
    s.dependency 'HandyJSON'
    s.dependency 'SwifterSwift'
    s.dependency 'EmptyDataSet-Swift'
    s.dependency 'CryptoSwift'
    s.dependency 'SwiftyRSA'
    s.dependency 'MJRefresh'
    s.dependency 'IQKeyboardManagerSwift'
    s.dependency 'UITableView+FDTemplateLayoutCell'
    s.dependency 'SKPhotoBrowser'
    s.dependency 'GPUImage'
    s.dependency 'RZCarPlateNoTextField'
    s.dependency 'URLNavigator'
    s.dependency 'WKWebViewJavascriptBridge'
    s.dependency 'YHLCore'
end
