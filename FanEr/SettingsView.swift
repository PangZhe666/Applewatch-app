import SwiftUI

/// 设置页：BYOK（自带 Key）配置的界面骨架，包含转写服务、大模型、API Key 与连通性测试
struct SettingsView: View {
    @State private var transcriptionProvider = "本机转写（免费）"
    @State private var llmProvider = "DeepSeek"
    @State private var apiKey = ""
    @State private var isTesting = false
    @State private var testResult: String?

    private let transcriptionProviders = ["本机转写（免费）", "火山引擎", "腾讯云", "阿里云百炼", "小米 MiMo", "自部署"]
    private let llmProviders = ["DeepSeek", "通义千问", "豆包", "Kimi"]

    /// 构建设置页视图
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("转写服务", selection: $transcriptionProvider) {
                        ForEach(transcriptionProviders, id: \.self) { provider in
                            Text(provider).tag(provider)
                        }
                    }
                } header: {
                    Text("转写")
                } footer: {
                    Text("本机转写零成本、不联网；云端转写需填入对应服务商的 Key。")
                }

                Section {
                    Picker("大模型", selection: $llmProvider) {
                        ForEach(llmProviders, id: \.self) { provider in
                            Text(provider).tag(provider)
                        }
                    }

                    SecureField("API Key", text: $apiKey)

                    Button(action: runConnectivityTest) {
                        HStack {
                            Text("连通性测试")
                            Spacer()
                            if isTesting {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(isTesting)
                } header: {
                    Text("AI 服务（BYOK）")
                } footer: {
                    Text("文本直接发往你选择的服务商，不经过饭耳服务器。")
                }

                if let testResult {
                    Section {
                        Text(testResult)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("存储") {
                    LabeledContent("iCloud 归档", value: "未开启")
                    LabeledContent("NAS 同步", value: "未配置")
                }

                Section("关于") {
                    LabeledContent("版本", value: "0.1.0（骨架）")
                }
            }
            .navigationTitle("设置")
        }
    }

    /// 模拟一次连通性测试（骨架阶段不发起真实网络请求）
    private func runConnectivityTest() {
        isTesting = true
        testResult = nil

        Task {
            try? await Task.sleep(nanoseconds: 600_000_000)
            isTesting = false
            testResult = apiKey.isEmpty
                ? "尚未填写 API Key：骨架阶段仅演示界面，接入后会真实请求服务商。"
                : "骨架阶段不做真实请求，接入后会使用 \(llmProvider) 校验 Key 是否可用。"
        }
    }
}

#Preview {
    SettingsView()
}
