import SwiftUI
import MapKit

struct HomeView: View {
    @ObservedObject var locationManager: LocationManager
    
    @State private var activeTab: Tab = .map
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var showMyDetail = false
    @State private var selectedFriend: Friend?

    var body: some View {
        ZStack {
            // ==============================
            // 1. 底層：切換畫面 (地圖、聊天等)
            // ==============================
            Group {
                if activeTab == .map {
                    Map(position: $cameraPosition) {
                        if let myLoc = locationManager.userLocation {
                            Annotation("我的位置", coordinate: myLoc) {
                                ZStack {
                                    Circle().fill(.blue.opacity(0.2)).frame(width: 80, height: 80)
                                    Circle().fill(.white).frame(width: 28, height: 28)
                                    Circle().fill(.blue).frame(width: 22, height: 22)
                                }
                                .onTapGesture { showMyDetail = true }
                            }
                        }
                        ForEach(mockFriends) { friend in
                            Annotation(friend.name, coordinate: friend.coordinate) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(friend.avatarColor)
                                    .background(Circle().fill(Color.white))
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                                    .onTapGesture { selectedFriend = friend }
                            }
                        }
                    }
                    .mapControls { MapCompass() }
                } else if activeTab == .chat {
                    ChatView()
                } else if activeTab == .notification {
                    NotificationView()
                } else if activeTab == .profile {
                    ProfileView(locationManager: locationManager)
                }
            }
            .transition(.opacity)
            
            // ==============================
            // 2. 右下角：定位按鈕 (移到下方，釋放上方空間)
            // ==============================
            if activeTab == .map {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            if let myLoc = locationManager.userLocation {
                                withAnimation {
                                    cameraPosition = .region(MKCoordinateRegion(center: myLoc, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                                }
                            }
                        }) {
                            Image(systemName: "location.fill")
                                .font(.title3)
                                .padding(12)
                                .background(Color(uiColor: .systemBackground))
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 30) // 距離底部稍微拉開
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: activeTab)
        
        // ==============================
        // 🌟 3. 核心魔法：將膠囊掛載在 Safe Area 頂部
        // ==============================
        .safeAreaInset(edge: .bottom) {
                    DynamicBottomPill(activeTab: $activeTab, locationManager: locationManager)
                }
        
        // 👉 我的與好友狀態彈窗 (保持不變)
        .sheet(isPresented: $showMyDetail) {
            VStack(spacing: 25) { UserStatusView(locationManager: locationManager); Spacer() }
                .presentationDetents([.medium])
        }
        .sheet(item: $selectedFriend) { friend in
            VStack(spacing: 20) { FriendRowView(friend: friend, onNotifyTapped: { locationManager.setupGeofence(for: friend) }, onRouteTapped: {}).padding(); Spacer() }
                .presentationDetents([.height(300), .medium])
        }
    }
}
