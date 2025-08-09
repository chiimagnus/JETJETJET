import SwiftUI
import SwiftData

struct FlightHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \FlightSession.startTime, order: .reverse) private var flightSessions: [FlightSession]
    @State private var viewModel = FlightHistoryVM()
    @State private var showSearchBar = false
    @FocusState private var isSearchFocused: Bool

    // 使用 @State 缓存过滤结果，避免频繁重新计算
    @State private var filteredSessions: [FlightSession] = []
    @State private var searchTask: Task<Void, Never>?

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
                        // 飞行记录列表 - 性能优化
                        LazyVStack(spacing: 16, pinnedViews: []) {
                            if filteredSessions.isEmpty {
                                emptyStateView
                                    .id("empty-state") // 添加稳定的ID
                            } else {
                                ForEach(filteredSessions, id: \.id) { session in
                                    FlightRecordCard(session: session, viewModel: viewModel)
                                        .id(session.id) // 确保稳定的ID
                                }
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: filteredSessions.count) // 只对数量变化添加动画
                        .padding(.horizontal, 20)
                        .padding(.top, 20) // 增加顶部间距，避免与导航栏重叠

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

            // 初始化过滤结果
            updateFilteredSessions()

            // 异步预加载音效，避免阻塞主线程
            Task.detached(priority: .background) {
                SoundService.shared.preloadSound("Whoosh Sound Effect")
            }
        }
        .onChange(of: flightSessions) { _, _ in
            updateFilteredSessions()
        }
        .onChange(of: viewModel.searchText) { _, _ in
            performSearch()
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

                if showSearchBar {
                    // 搜索栏展开状态
                    HStack(spacing: 12) {
                        SearchBar(searchText: $viewModel.searchText)

                        Button(action: {
                            // // 异步播放音效，避免阻塞UI
                            // Task.detached(priority: .userInitiated) {
                            //     SoundService.shared.playSound("Whoosh Sound Effect", volume: 0.6, duration: 1.5)
                            // }

                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSearchBar = false
                                viewModel.searchText = ""
                                isSearchFocused = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(.title3, weight: .medium))
                                .foregroundColor(.cyan)
                        }
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                } else {
                    // 正常状态 - 标题居中，搜索按钮在右侧
                    Text(NSLocalizedString("flight_history_title", comment: "Flight history view title"))
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(1)
                        .frame(maxWidth: .infinity) // 让标题占据可用空间并居中
                        .transition(.move(edge: .leading).combined(with: .opacity))

                    Button(action: {
                        // 异步播放音效，避免阻塞UI
                        Task.detached(priority: .userInitiated) {
                            SoundService.shared.playSound("Whoosh Sound Effect", volume: 0.6, duration: 1.5)
                        }

                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSearchBar = true
                        }
                        // 延迟一点时间让动画完成后再获得焦点
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isSearchFocused = true
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(.title3, weight: .medium))
                            .foregroundColor(.cyan)
                    }
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
            Text("🚀")
                .font(.system(size: 64))
                .opacity(0.5)

            VStack(spacing: 8) {
                Text(NSLocalizedString("flight_history_empty_title", comment: "Flight history empty state title"))
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .foregroundColor(.white)

                Text(NSLocalizedString("flight_history_empty_subtitle", comment: "Flight history empty state subtitle"))
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

                Text(NSLocalizedString("flight_history_new_flight_button", comment: "New flight button title"))
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
                            colors: [
                                Color(red: 0, green: 1, blue: 0.53), // 霓虹绿色 #00ff88
                                Color(red: 0, green: 0.83, blue: 1) // 霓虹青色 #00d4ff
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(red: 0, green: 1, blue: 0.53).opacity(0.5), radius: 16, x: 0, y: 6) // 增强绿色发光
                    .shadow(color: Color(red: 0, green: 0.83, blue: 1).opacity(0.3), radius: 12, x: 0, y: 0) // 青色发光
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - 性能优化方法

    /// 更新过滤结果（同步，用于初始化）
    private func updateFilteredSessions() {
        filteredSessions = viewModel.filteredSessions(flightSessions)
    }

    /// 执行搜索（异步，防抖）
    private func performSearch() {
        // 取消之前的搜索任务
        searchTask?.cancel()

        // 创建新的搜索任务，添加防抖延迟
        searchTask = Task {
            // 防抖延迟 300ms
            try? await Task.sleep(nanoseconds: 300_000_000)

            // 检查任务是否被取消
            guard !Task.isCancelled else { return }

            // 在主线程更新UI
            await MainActor.run {
                filteredSessions = viewModel.filteredSessions(flightSessions)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FlightHistoryView()
    }
    .modelContainer(for: [FlightData.self, FlightSession.self], inMemory: true)
    .environment(LightSourceSettings())
    .preferredColorScheme(.dark)
}
