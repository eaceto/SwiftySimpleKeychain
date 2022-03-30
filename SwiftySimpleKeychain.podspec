# BEGIN CI/CD Space
libraryName = "SwiftySimpleKeychain"
libraryVersion = "1.0.1"
# END CI/CD Space

Pod::Spec.new do |s|
    s.name          = libraryName
    s.version       = libraryVersion
    s.summary       = "A (Simple) Keychain Wrapper written in Swift!"

    s.homepage      = "https://github.com/eaceto/SwiftySimpleKeychain"
    s.license       = { :type => "MIT", :file => "LICENSE" }
    s.author        = { "Ezequiel (Kimi) Aceto" => "ezequiel.aceto@gmail.com" }

    s.source        = {
        :git    => "https://github.com/eaceto/SwiftySimpleKeychain.git",
        :tag    => s.version.to_s
    }

    s.swift_versions = ['5.3', '5.4', '5.5']

    s.cocoapods_version = ">= 1.4.0"    

    s.frameworks = "Foundation"

    s.ios.deployment_target = "11.0"
    s.macos.deployment_target = "10.12"
    s.watchos.deployment_target = "5"
    s.tvos.deployment_target = "11"

    s.ios.framework  = 'LocalAuthentication'
    s.osx.framework  = 'LocalAuthentication'

    s.source_files = "Sources/#{libraryName}/**/*"

    s.subspec "RSAHelper" do |helper|

        helper.ios.deployment_target = "11.0"
        helper.macos.deployment_target = "10.12"
        helper.watchos.deployment_target = "5"
        helper.tvos.deployment_target = "11"
    
        helper.source_files = [
            "Sources/#{libraryName}/**/*",
            "Sources/#{libraryName}_RSAHelper/**/*"    
        ]

    end
end