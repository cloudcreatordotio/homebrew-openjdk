cask 'adoptopenjdk11-openj9' do
  version '11.0.2,9'
  sha256 '759c857b6fef2c44baadaa4245182e15c9ad1834cb0361358b13ac1f8fcb2692'

  # github.com/AdoptOpenJDK was verified as official when first introduced to the cask
  url "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-#{version.before_comma}%2B#{version.after_comma}_openj9-0.12.1/OpenJDK11U-jdk_x64_mac_openj9_#{version.before_comma}_#{version.after_comma}_openj9-0.12.1_openj9-0.12.1.tar.gz"
  appcast 'https://github.com/adoptopenjdk/openjdk11-binaries/releases.atom'
  name 'AdoptOpenJDK'
  homepage 'https://adoptopenjdk.net/'

  postflight do
    system_command '/bin/mv',
                   args: [
                           '-f', '--', "#{staged_path}/jdk-#{version.before_comma}+#{version.after_comma}_openj9-0.12.1",
                           "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk"
                         ],
                   sudo: true

    system_command '/bin/mkdir',
                   args: ['-p', '--', "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk/Contents/Home/bundle/Libraries"],
                   sudo: true

    system_command '/bin/ln',
                   args: [
                           '-nsf', '--',
                           "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk/Contents/Home/lib/server/libjvm.dylib",
                           "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk/Contents/Home/bundle/Libraries/libserver.dylib"
                         ],
                   sudo: true

    system_command '/usr/libexec/PlistBuddy',
                   args: [
                           '-c', "Set :CFBundleGetInfoString AdoptOpenJDK (OpenJ9) #{version.before_comma}+#{version.after_comma}",
                           "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk/Contents/Info.plist"
                         ],
                   sudo: true

    system_command '/usr/libexec/PlistBuddy',
                   args: [
                           '-c', "Set :CFBundleIdentifier net.adoptopenjdk.#{version.before_comma}-openj9.jdk",
                           "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk/Contents/Info.plist"
                         ],
                   sudo: true

    system_command '/usr/libexec/PlistBuddy',
                   args: [
                           '-c', "Set :CFBundleName AdoptOpenJDK (OpenJ9) #{version.before_comma}",
                           "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk/Contents/Info.plist"
                         ],
                   sudo: true

    system_command '/usr/libexec/PlistBuddy',
                   args: [
                           '-c', "Set :JavaVM:JVMPlatformVersion #{version.before_comma}.#{version.after_comma}",
                           "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk/Contents/Info.plist"
                         ],
                   sudo: true

    system_command '/usr/libexec/PlistBuddy',
                   args: [
                           '-c', 'Set :JavaVM:JVMVendor AdoptOpenJDK',
                           "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk/Contents/Info.plist"
                         ],
                   sudo: true
  end

  uninstall delete: "/Library/Java/JavaVirtualMachines/adoptopenjdk-#{version.before_comma}-openj9.jdk"
end
