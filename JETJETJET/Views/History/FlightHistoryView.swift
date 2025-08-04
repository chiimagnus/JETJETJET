import SwiftUI
import SwiftData

struct FlightHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \FlightSession.startTime, order: .reverse) private var flightSessions: [FlightSession]
    @State private var viewModel = FlightHistoryVM()
    @State private var showSearchBar = false

    private var filteredSessions: [FlightSession] {
        viewModel.filteredSessions(flightSessions)
    }

    var body: some View {
        ZStack {
            // 静态星空背景 - 历史记录页面使用默认参数
            StarfieldBackgroundView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 顶部导航栏
                topNavigationBar

                ScrollView {
                    VStack(spacing: 20) {
                        // 搜索栏 - 按需显示
                        if showSearchBar {
                            SearchBar(searchText: $viewModel.searchText)
                                .padding(.horizontal, 20)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        // 飞行记录列表
                        LazyVStack(spacing: 16) {
                            if filteredSessions.isEmpty {
                                emptyStateView
                            } else {
                                ForEach(filteredSessions, id: \.id) { session in
                                    NavigationLink(destination: AirplaneModelView(session: session)) {
                                        FlightRecordCardWithStats(session: session, viewModel: viewModel)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        // 新建飞行按钮
                        newFlightButton
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }
                }

                // 错误信息显示
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                        .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            print("FlightHistoryView appeared!")
            viewModel.setModelContext(modelContext)
        }
    }

    // MARK: - 顶部导航栏
    private var topNavigationBar: some View {
        GlassCard {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(.title3, weight: .medium))
                        .foregroundColor(.cyan)
                }

                Spacer()

                Text("JET LOGS")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(1)

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSearchBar.toggle()
                    }
                    if !showSearchBar {
                        viewModel.searchText = ""
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(.title3, weight: .medium))
                        .foregroundColor(showSearchBar ? Color(red: 0, green: 0.83, blue: 1) : .cyan)
                }
            }
            .padding()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    // MARK: - 空状态视图
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Text("✈️")
                .font(.system(size: 64))
                .opacity(0.5)

            VStack(spacing: 8) {
                Text("暂无飞行记录")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .foregroundColor(.white)

                Text("开始你的第一次飞行记录吧！")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 60)
    }

    // MARK: - 新建飞行按钮
    private var newFlightButton: some View {
        Button(action: {
            // 返回主界面开始新的飞行记录
            dismiss()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.system(.title3, weight: .bold))

                Text("NEW FLIGHT")
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .tracking(2)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.green, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 带统计数据的飞行记录卡片
struct FlightRecordCardWithStats: View {
    let session: FlightSession
    let viewModel: FlightHistoryVM

    var body: some View {
        let stats = viewModel.getFlightStats(for: session)

        VStack(spacing: 0) {
            // 顶部彩色渐变条
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.cyan, .green, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 3)

            VStack(spacing: 16) {
                // 日期和状态行
                HStack {
                    HStack(spacing: 12) {
                        Text("📅")
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(formatDate(session.startTime))
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .foregroundColor(.white)

                            Text(formatTime(session.startTime))
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()

                    // 飞行状态指示器
                    FlightStatusIndicator()
                }

                // 飞行时长和描述
                HStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Text("⏱️")
                            .font(.body)
                        Text(session.formattedDuration)
                            .font(.system(.body, design: .rounded, weight: .bold))
                            .foregroundColor(.cyan)
                    }

                    HStack(spacing: 8) {
                        Text("🛫")
                            .font(.body)
                        Text(session.flightDescription)
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }

                // 数据标签网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    DataTag(value: stats.formattedMaxSpeed, label: "Max Speed", color: .cyan)
                    DataTag(value: stats.formattedMaxPitch, label: "Max Pitch", color: .green)
                    DataTag(value: stats.formattedMaxRoll, label: "Max Roll", color: .orange)
                    DataTag(value: stats.formattedMaxG, label: "Max G", color: .purple)
                }

                // 回放按钮
                ReplayButton {
                    // 导航到3D回放视图
                    print("回放飞行记录: \(session.id)")
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        FlightHistoryView()
    }
    .modelContainer(for: [FlightData.self, FlightSession.self], inMemory: true)
    .preferredColorScheme(.dark)
}

#Preview {
    FlightHistoryView()
        .modelContainer(for: [FlightData.self, FlightSession.self], inMemory: true)
}
