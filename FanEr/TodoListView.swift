import Foundation
import SwiftUI

/// 待办卡的三种状态
private enum TodoStatus {
    case pending
    case done
    case snoozed
}

/// 待办卡占位数据（后续由 AI 整理阶段从对话中提取）
private struct TodoCard: Identifiable {
    let id = UUID()
    let content: String
    let owner: String
    let spokeAt: String
    let context: String
    var status: TodoStatus = .pending
}

/// 「待办」页：待办卡列表，右滑标记完成、左滑设为稍后提醒
struct TodoListView: View {
    @State private var cards: [TodoCard] = [
        TodoCard(content: "把样品收货地址发给供应商",
                 owner: "我答应别人",
                 spokeAt: "今天 10:32",
                 context: "“地址我今天整理好发你，周五前能寄出吗？”"),
        TodoCard(content: "周五前寄出样品",
                 owner: "别人答应我",
                 spokeAt: "今天 10:33",
                 context: "“可以，周五前一定寄出。”"),
        TodoCard(content: "周三前完成设计稿评审",
                 owner: "我答应别人",
                 spokeAt: "今天 09:06",
                 context: "“评审我来约，周三之前搞完。”")
    ]

    /// 构建待办页视图
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach($cards) { $card in
                        cardRow(card)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    card.status = .done
                                } label: {
                                    Label("做完了", systemImage: "checkmark")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    card.status = .snoozed
                                } label: {
                                    Label("稍后提醒", systemImage: "clock")
                                }
                                .tint(.orange)
                            }
                    }
                } header: {
                    Text("待确认与进行中")
                } footer: {
                    Text("右滑 = 做完了 / 不用做，左滑 = 稍后提醒（骨架阶段仅在本地切换卡片状态）")
                }
            }
            .navigationTitle("待办")
        }
    }

    /// 构建单张待办卡
    /// - Parameter card: 待办卡数据
    private func cardRow(_ card: TodoCard) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(card.owner)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.15), in: Capsule())
                    .foregroundStyle(.blue)

                Text(card.spokeAt)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                statusBadge(card.status)
            }

            Text(card.content)
                .font(.headline)
                .strikethrough(card.status == .done)
                .foregroundStyle(card.status == .done ? .secondary : .primary)

            Text(card.context)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }

    /// 构建状态角标
    /// - Parameter status: 待办卡状态
    @ViewBuilder
    private func statusBadge(_ status: TodoStatus) -> some View {
        switch status {
        case .pending:
            EmptyView()
        case .done:
            Label("已完成", systemImage: "checkmark.circle.fill")
                .font(.caption2)
                .foregroundStyle(.green)
        case .snoozed:
            Label("已稍后", systemImage: "clock.fill")
                .font(.caption2)
                .foregroundStyle(.orange)
        }
    }
}

#Preview {
    TodoListView()
}
