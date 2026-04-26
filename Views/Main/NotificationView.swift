import SwiftUI

struct NotificationView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("今天")) {
                    NotifRow(icon: "figure.walk", color: .green, title: "女友 已抵達 公司", time: "09:05")
                    NotifRow(icon: "battery.25", color: .red, title: "老爸 的手機電量低於 20%", time: "08:30")
                }
                
                Section(header: Text("昨天")) {
                    NotifRow(icon: "house.fill", color: .blue, title: "老媽 已離開 家裡", time: "18:45")
                    NotifRow(icon: "exclamationmark.triangle.fill", color: .orange, title: "老爸 關閉了位置分享", time: "12:00")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("活動通知")
            .safeAreaPadding(.leading, 60)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

// 通知的單一行元件
struct NotifRow: View {
    let icon: String
    let color: Color
    let title: String
    let time: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(color.gradient)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline)
                Text(time).font(.caption).foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}
