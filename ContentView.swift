import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        Group {
            if locationManager.authorizationStatus == .notDetermined {
                PermissionView(locationManager: locationManager)
            } else if locationManager.authorizationStatus == .authorizedAlways ||
                      locationManager.authorizationStatus == .authorizedWhenInUse {
                // 已授權，進入全螢幕地圖/抽屜視圖
                HomeView(locationManager: locationManager)
            } else {
                VStack {
                    Text("需要定位權限才能使用 WhereRU")
                    Button("前往設定開啟") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        }
        .animation(.default, value: locationManager.authorizationStatus)
    }
}

// ==========================================
// MARK: - 🌟 補回被遺忘的權限請求精美畫面
// ==========================================
struct PermissionView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "location.magnifyingglass")
                .font(.system(size: 100))
                .foregroundColor(.blue)
                .symbolEffect(.pulse)
            
            Text("WhereRU")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
            
            Text("為了守護家人的安全，\n請允許我們在背景持續更新您的位置。")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer().frame(height: 50)
            
            Button(action: {
                locationManager.requestPermission()
            }) {
                Text("啟用安全防護網")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 40)
        }
    }
}
