import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationView {
            List {
                ChatRow(name: "女友", message: "你下班離開園區了嗎？", time: "剛剛", unread: 1, color: .pink)
                ChatRow(name: "老爸", message: "幫我買個晚餐回來", time: "10:30", unread: 0, color: .orange)
                ChatRow(name: "老媽", message: "週末要不要回家吃飯？", time: "昨天", unread: 0, color: .purple)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("聊天")
            // 🌟 為了讓左側導覽列不被擋住，我們把內容往右推
            .safeAreaPadding(.leading, 60)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

// 聊天的單一行元件
struct ChatRow: View {
    let name: String
    let message: String
    let time: String
    let unread: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(color.gradient)
                .frame(width: 50, height: 50)
                .overlay(Text(String(name.prefix(1))).font(.title3).bold().foregroundColor(.white))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name).font(.headline)
                Text(message).font(.subheadline).foregroundColor(.secondary).lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(time).font(.caption).foregroundColor(unread > 0 ? .blue : .secondary)
                if unread > 0 {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .overlay(Text("\(unread)").font(.caption2).bold().foregroundColor(.white))
                }
            }
        }
        .padding(.vertical, 4)
    }
}
