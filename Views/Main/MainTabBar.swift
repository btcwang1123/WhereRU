import SwiftUI

enum Tab {
    case map, chat, notification, profile
}

struct MainTabBar: View {
    @Binding var activeTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(tab: .map, label: "地圖", systemImage: "map.fill", activeTab: $activeTab)
            TabBarButton(tab: .chat, label: "聊天", systemImage: "bubble.left.and.bubble.right.fill", activeTab: $activeTab)
            TabBarButton(tab: .notification, label: "通知", systemImage: "bell.fill", activeTab: $activeTab)
            TabBarButton(tab: .profile, label: "個人", systemImage: "person.crop.circle.fill", activeTab: $activeTab)
        }
        .padding(.vertical, 12) // 讓上下間距更平均
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
