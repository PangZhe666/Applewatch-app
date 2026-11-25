import Foundation
import SwiftUI

/// Watch 端录音主界面：只显示录音状态、时长与停止按钮（骨架阶段未接入真实录音）
struct RecordingView: View {
    @State private var isRecording = true
    @State private var recordingStart = Date()
    @State private var frozenElapsed: TimeInterval = 0

    /// 构建录音主界面
    var body: some View {
        VStack(spacing: 8) {
            Text(isRecording ? "正在录音" : "待命")
                .font(.footnote.weight(.medium))
                .foregroundStyle(isRecording ? Color.red : Color.secondary)

            // 只刷新文字，不做波形等高频刷新，以控制电量消耗
            TimelineView(.periodic(from: .now, by: 1)) { context in
                Text(formatted(elapsed(at: context.date)))
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .monospacedDigit()
            }

            Button(action: toggleRecording) {
                Label(isRecording ? "停止" : "开始", systemImage: isRecording ? "stop.fill" : "mic.fill")
            }
            .tint(isRecording ? .red : .green)

            Text("每 15 分钟分块传到 iPhone")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 4)
    }

    /// 计算当前应显示的录音时长
    /// - Parameter date: TimelineView 提供的当前时间
    /// - Returns: 已录制的秒数
    private func elapsed(at date: Date) -> TimeInterval {
        isRecording ? date.timeIntervalSince(recordingStart) : frozenElapsed
    }

    /// 切换录音状态（骨架阶段仅做界面状态切换，不启动音频会话）
    private func toggleRecording() {
        if isRecording {
            frozenElapsed = Date().timeIntervalSince(recordingStart)
            isRecording = false
        } else {
            recordingStart = Date()
            isRecording = true
        }
    }

    /// 把秒数格式化为 HH:MM:SS
    /// - Parameter interval: 秒数
    private func formatted(_ interval: TimeInterval) -> String {
        let total = max(0, Int(interval))
        return String(format: "%02d:%02d:%02d", total / 3600, (total % 3600) / 60, total % 60)
    }
}

#Preview {
    RecordingView()
}
