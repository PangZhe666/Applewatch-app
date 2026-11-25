import SwiftUI

/// 应用根视图：底部四个主入口（今天 / 待办 / 小耳 / 设置）
struct RootTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("今天", systemImage: "calendar") }

            TodoListView()
                .tabItem { Label("待办", systemImage: "checklist") }

            AssistantView()
                .tabItem { Label("小耳", systemImage: "sparkles") }

            SettingsView()
                .tabItem { Label("设置", systemImage: "gearshape") }
        }
    }
}

#Preview {
    RootTabView()
}
