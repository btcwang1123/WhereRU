import SwiftUI

enum Tab {
    case map, chat, notification, profile
}

struct MainTabBar: View {
    @Binding var activeTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(tab: .map, label: "聯絡人", systemImage: "person.2.fill", activeTab: $activeTab)
            TabBarButton(tab: .chat, label: "裝置", systemImage: "macbook.and.iphone", activeTab: $activeTab)
            TabBarButton(tab: .notification, label: "物品", systemImage: "square.grid.2x2.fill", activeTab: $activeTab)
            TabBarButton(tab: .profile, label: "本人", systemImage: "location.fill", activeTab: $activeTab)
        }
        .padding(.top, 10)
        // 🌟 移除了這裡的 background，讓它融入外層膠囊
    }
}

struct TabBarButton: View {
    let tab: Tab
    let label: String
    let systemImage: String
    @Binding var activeTab: Tab
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            withAnimation { activeTab = tab }
        }) {
            VStack(spacing: 4) {
                Image(systemName: systemImage).font(.system(size: 22))
                Text(label).font(.system(size: 10, weight: .bold))
            }
            .foregroundColor(activeTab == tab ? .blue : .secondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
