import SwiftUI

struct DynamicBottomPill: View {
    @Binding var activeTab: Tab
    @ObservedObject var locationManager: LocationManager
    
    // 🌟 控制清單是否展開
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // ==============================
            // 1. 頂部把手區 (永遠顯示，點擊可展開/收合)
            // ==============================
            VStack {
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle()) // 讓整個頂端區塊都能感應點擊
            .onTapGesture {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }
            // 加入滑動手勢，往上滑展開，往下滑收合
            .gesture(
                DragGesture().onEnded { value in
                    if value.translation.height < -20 {
                        withAnimation(.spring()) { isExpanded = true }
                    } else if value.translation.height > 20 {
                        withAnimation(.spring()) { isExpanded = false }
                    }
                }
            )

            // ==============================
            // 2. 展開後的內容區 (親友動態)
            // ==============================
            if isExpanded {
                VStack(spacing: 0) {
                    Divider().padding(.horizontal)
                    
                    if activeTab == .map {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(mockFriends) { friend in
                                    FriendRowView(friend: friend, onNotifyTapped: {
                                        locationManager.setupGeofence(for: friend)
                                    }, onRouteTapped: {})
                                    .padding(.horizontal)
                                    Divider().padding(.leading, 70)
                                }
                            }
                            .padding(.top, 8)
                        }
                        // 限制最高高度，避免遮住全螢幕
                        .frame(maxHeight: UIScreen.main.bounds.height * 0.45)
                    } else if activeTab == .profile {
                        UserStatusView(locationManager: locationManager)
                            .padding()
                    } else {
                        // 預留其他頁面空間
                        Text("內容開發中...")
                            .foregroundColor(.secondary)
                            .frame(height: 150)
                    }
                    
                    Divider().padding(.horizontal)
                }
                // 淡入並從下方滑出的動畫效果
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // ==============================
            // 3. 常駐導覽列 (TabBar)
            // ==============================
            MainTabBar(activeTab: $activeTab)
                .padding(.bottom, 12) // 底部預留一點安全距離
        }
        // 🌟 整個膠囊共用一塊高質感的毛玻璃背景
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 15, y: 5)
        .padding(.horizontal, 16)
        .padding(.bottom, 10) // 避開 iPhone 底部的系統黑線
    }
}
