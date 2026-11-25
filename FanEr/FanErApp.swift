import SwiftUI

/// 饭耳 iPhone 端入口：承载转写、AI 整理、待办卡与小耳助理
@main
struct FanErApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}
