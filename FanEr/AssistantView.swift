import Foundation
import SwiftUI

/// 一条对话消息
private struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

/// 小耳 AI 助理页：对话式问答界面骨架（尚未接入真实大模型）
struct AssistantView: View {
    @State private var draft = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "我在。今天想先看哪一段对话？", isUser: false),
        ChatMessage(text: "今天答应了谁什么？", isUser: true),
        ChatMessage(text: "今天 10:32，你答应供应商把样品收货地址今天发过去。", isUser: false)
    ]

    /// 构建小耳助理页视图
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(messages) { message in
                            bubble(message)
                        }
                    }
                    .padding(16)
                }

                inputBar
            }
            .navigationTitle("小耳")
        }
    }

    /// 构建单条消息气泡
    /// - Parameter message: 消息数据
    private func bubble(_ message: ChatMessage) -> some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }

            Text(message.text)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(
                    message.isUser ? Color.accentColor : Color(.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: 14)
                )
                .foregroundStyle(message.isUser ? .white : .primary)

            if !message.isUser { Spacer(minLength: 40) }
        }
    }

    /// 底部输入栏（骨架阶段仅把输入内容追加到本地列表）
    private var inputBar: some View {
        HStack(spacing: 8) {
            TextField("问点什么，比如“昨天发生了什么”", text: $draft, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))

            Button(action: send) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
            }
            .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.bar)
    }

    /// 发送当前输入内容
    private func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        messages.append(ChatMessage(text: text, isUser: true))
        draft = ""
    }
}

#Preview {
    AssistantView()
}
