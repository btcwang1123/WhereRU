import SwiftUI

struct MainTabView: View {
    @ObservedObject var locationManager: LocationManager
    // 控制目前的 Tab
    @State private var activeTab = 0
    
    var body: some View {
        TabView(selection: $activeTab) {
            
            // 1. 聯絡人 (地圖主畫面)
            HomeView(locationManager: locationManager)
                .tabItem {
                    Label("聯絡人", systemImage: "person.2.fill")
                }
                .tag(0)
            
            // 2. 裝置
            Text("裝置清單開發中...")
                .tabItem {
                    Label("裝置", systemImage: "macbook.and.iphone")
                }
                .tag(1)
            
            // 3. 物品
            Text("物品追蹤開發中...")
                .tabItem {
                    Label("物品", systemImage: "square.grid.2x2.fill")
                }
                .tag(2)
            
            // 4. 本人 (個人設定)
            ProfileView(locationManager: locationManager)
                .tabItem {
                    Label("本人", systemImage: "location.fill")
                }
                .tag(3)
        }
        // 讓 TabBar 呈現跟尋找 App 一樣的半透明材質
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
