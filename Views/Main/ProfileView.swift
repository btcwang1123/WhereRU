import SwiftUI

struct ProfileView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var isGhostMode = false
    @State private var shareBattery = true
    
    var body: some View {
        NavigationView {
            Form {
                // 1. 個人狀態區塊
                Section {
                    UserStatusView(locationManager: locationManager)
                        .listRowInsets(EdgeInsets()) // 移除邊界讓卡片滿版
                        .background(Color.clear)
                }
                
                // 2. 隱私與安全設定
                Section(header: Text("隱私與安全"), footer: Text("開啟幽靈模式後，親友只能看到您模糊的粗略位置，無法看到精確座標。")) {
                    Toggle(isOn: $isGhostMode) {
                        Label("幽靈模式", systemImage: "ghost.fill")
                            .foregroundColor(.purple)
                    }
                    
                    Toggle(isOn: $shareBattery) {
                        Label("分享設備電量", systemImage: "battery.100")
                            .foregroundColor(.green)
                    }
                }
                
                // 3. 系統設定
                Section {
                    Button(action: {}) {
                        Label("緊急聯絡人設定", systemImage: "cross.case.fill")
                            .foregroundColor(.red)
                    }
                    Button(action: {}) {
                        Label("登出", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("個人設定")
            .safeAreaPadding(.leading, 60)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}
