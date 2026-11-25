import SwiftUI

/// 饭耳 Watch 端入口：打开即进入持续录音主界面
@main
struct FanErWatchApp: App {
    var body: some Scene {
        WindowGroup {
            RecordingView()
        }
    }
}
