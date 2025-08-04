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
                                        FlightRecordCard(session: session, viewModel: viewModel)
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
