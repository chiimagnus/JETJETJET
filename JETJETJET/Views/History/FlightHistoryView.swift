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
                        // 飞行记录列表
                        LazyVStack(spacing: 16) {
                            if filteredSessions.isEmpty {
                                emptyStateView
                            } else {
                                ForEach(filteredSessions, id: \.id) { session in
                                    FlightRecordCard(session: session, viewModel: viewModel)
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

                if showSearchBar {
                    // 搜索栏展开状态
                    HStack(spacing: 12) {
                        SearchBar(searchText: $viewModel.searchText)

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSearchBar = false
                                viewModel.searchText = ""
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
                    Text("JET LOGS")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(1)
                        .frame(maxWidth: .infinity) // 让标题占据可用空间并居中
                        .transition(.move(edge: .leading).combined(with: .opacity))

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSearchBar = true
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
}

#Preview {
    NavigationView {
        FlightHistoryView()
    }
    .modelContainer(for: [FlightData.self, FlightSession.self], inMemory: true)
    .preferredColorScheme(.dark)
}


