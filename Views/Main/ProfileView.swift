import SwiftUI

struct ProfileView: View {
    @ObservedObject var locationManager: LocationManager
    
    // 🌟 就是少這兩行！必須放在這裡，按鈕才找得到它們
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("appleUserId") var appleUserId = ""
    
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
                            .foregroundColor(.red) // 警告色統一
                    }
                    Button(action: {
                        // 加入微小的震動回饋，提升手感
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        // 🌟 登出邏輯：把狀態改回 false，清空資料
                        withAnimation {
                            isLoggedIn = false
                            appleUserId = ""
                        }
                    }) {
                        Label("登出", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("個人設定")
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}
