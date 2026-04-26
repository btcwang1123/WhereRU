import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    // 🌟 破案關鍵：ContentView 必須要有這行，它才會知道 ProfileView 把狀態改成 false 了！
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        Group {
            // 1. 如果還沒登入 (isLoggedIn == false)，顯示登入頁面
            if !isLoggedIn {
                LoginView()
            }
            // 2. 如果已登入，但還沒給定位權限，顯示權限請求頁面
            else if locationManager.authorizationStatus == .notDetermined {
                PermissionView(locationManager: locationManager)
            }
            // 3. 登入且已給權限，進入 App 核心佈局 (帶有浮動膠囊的 HomeView)
            else if locationManager.authorizationStatus == .authorizedAlways ||
                      locationManager.authorizationStatus == .authorizedWhenInUse {
                
                HomeView(locationManager: locationManager)
                
            }
            // 4. 拒絕給予權限的防呆畫面
            else {
                VStack(spacing: 20) {
                    Image(systemName: "location.slash.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text("需要定位權限才能使用 WhereRU")
                        .font(.headline)
                    Button("前往設定開啟") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        // 🌟 確保登入/登出切換時，畫面會平滑過渡，不會生硬閃爍
        .animation(.easeInOut, value: isLoggedIn)
        .animation(.default, value: locationManager.authorizationStatus)
    }
}

// ==========================================
// 下方保留你原本的 PermissionView 程式碼...
// ==========================================
struct PermissionView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "location.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("WhereRU 需要您的位置")
                .font(.title2)
                .bold()
            
            Text("為了讓您的家人隨時知道您是否安全，請允許 App 存取您的位置資訊。")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: {
                locationManager.requestPermission()
            }) {
                Text("允許存取位置")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
        }
    }
}
