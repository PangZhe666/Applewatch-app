import SwiftUI

/// 「今天」页里的一个时段卡占位数据（对应一段 15 分钟录音的整理结果）
private struct TodaySegment: Identifiable {
    let id = UUID()
    let timeRange: String
    let title: String
    let summary: String
    let highlightCount: Int
    let todoCount: Int
}

/// 「今天」页：展示 Watch 录音状态与按时间段整理的对话卡片
struct TodayView: View {
    // 骨架阶段的占位数据，后续由转写 + AI 整理结果填充
    private let segments: [TodaySegment] = [
        TodaySegment(timeRange: "09:00 - 09:15", title: "早会同步",
                     summary: "确认了本周排期，周三前完成设计稿评审。",
                     highlightCount: 3, todoCount: 2),
        TodaySegment(timeRange: "10:30 - 10:45", title: "和供应商通话",
                     summary: "对方答应周五前寄出样品，地址今天发过去。",
                     highlightCount: 2, todoCount: 1),
        TodaySegment(timeRange: "14:00 - 14:15", title: "一个人走路",
                     summary: "想到两个点：中断后自动续录、每天 8:30 的早清单。",
                     highlightCount: 2, todoCount: 0)
    ]

    /// 构建「今天」页视图
    var body: some View {
        NavigationStack {
            List {
                Section {
                    recordingBanner
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowBackground(Color.clear)
                }

                Section("今日记录") {
                    ForEach(segments) { segment in
                        segmentRow(segment)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("今天")
        }
    }

    /// Watch 录音状态横幅（骨架阶段为示意文案）
    private var recordingBanner: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text("Watch 正在录音")
                    .font(.subheadline.weight(.semibold))
                Text("不按停就一直录，每 15 分钟分块传到手机")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    /// 构建单个时段卡
    /// - Parameter segment: 时段卡数据
    private func segmentRow(_ segment: TodaySegment) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(segment.timeRange)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if segment.highlightCount > 0 {
                    chip("重点 \(segment.highlightCount)", color: .blue)
                }
                if segment.todoCount > 0 {
                    chip("待办 \(segment.todoCount)", color: .orange)
                }
            }

            Text(segment.title)
                .font(.headline)

            Text(segment.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }

    /// 构建小标签
    /// - Parameters:
    ///   - text: 标签文字
    ///   - color: 标签底色
    private func chip(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15), in: Capsule())
            .foregroundStyle(color)
    }
}

#Preview {
    TodayView()
}
