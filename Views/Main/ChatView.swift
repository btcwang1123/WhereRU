import SwiftUI

// 1. 定義資料模型，讓代碼更整潔
struct ChatMessage: Identifiable {
    let id = UUID()
    let name: String
    let message: String
    let time: String
    let unreadCount: Int
    let color: Color
    let isOnline: Bool
}

struct ChatView: View {
    // 模擬資料
    @State private var searchText = ""
    @State private var chats = [
        ChatMessage(name: "女友", message: "你下班離開園區了嗎？🚗", time: "剛剛", unreadCount: 1, color: .pink, isOnline: true),
        ChatMessage(name: "老爸", message: "幫我買個晚餐回來，謝啦", time: "10:30", unreadCount: 0, color: .orange, isOnline: false),
        ChatMessage(name: "老媽", message: "週末要不要回家吃飯？🍚", time: "昨天", unreadCount: 0, color: .purple, isOnline: true),
        ChatMessage(name: "小明 (同事)", message: "那個 Bug 我修好了，你看一下", time: "昨天", unreadCount: 5, color: .blue, isOnline: true),
        ChatMessage(name: "國中同學會", message: "王小美：大家有空嗎？", time: "週三", unreadCount: 0, color: .green, isOnline: false)
    ]

    var body: some View {
        NavigationStack { // 建議改用 NavigationStack (iOS 16+)
            List {
                // 亮點 A: 頂部常用聯絡人 (Horizontal Scroll)
                Section {
                    FavoriteContactsHeader()
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // 亮點 B: 聊天列表
                Section {
                    ForEach(filteredChats) { chat in
                        EnhancedChatRow(chat: chat)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    // 刪除邏輯
                                } label: {
                                    Label("刪除", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    // 標記已讀邏輯
                                } label: {
                                    Label("標記已讀", systemImage: "checkmark.bubble")
                                }
                                .tint(.blue)
                            }
                    }
                } header: {
                    Text("最近訊息")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("聊天")
            .searchable(text: $searchText, prompt: "搜尋聯絡人或訊息")
            // 🌟 保留你原本的左側避讓位移
            //.safeAreaPadding(.leading, 60)
        }
    }

    var filteredChats: [ChatMessage] {
        if searchText.isEmpty { return chats }
        return chats.filter { $0.name.contains(searchText) || $0.message.contains(searchText) }
    }
}

// 亮點 C: 豐富的單列元件
struct EnhancedChatRow: View {
    let chat: ChatMessage
    
    var body: some View {
        HStack(spacing: 15) {
            // 頭像與在線狀態
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(chat.color.gradient)
                    .frame(width: 55, height: 55)
                    .overlay(
                        Text(String(chat.name.prefix(1)))
                            .font(.title3).bold().foregroundColor(.white)
                    )
                
                if chat.isOnline {
                    Circle()
                        .fill(.green)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(Color(uiColor: .systemGroupedBackground), lineWidth: 2))
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(chat.name).font(.headline)
                    Spacer()
                    Text(chat.time)
                        .font(.caption)
                        .foregroundColor(chat.unreadCount > 0 ? .blue : .secondary)
                }
                
                HStack {
                    Text(chat.message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if chat.unreadCount > 0 {
                        Text("\(chat.unreadCount)")
                            .font(.caption2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(.blue))
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }
}

// 亮點 A 的組件實作
struct FavoriteContactsHeader: View {
    let favorites = ["女友", "老爸", "老媽", "小明", "主管"]
    let colors: [Color] = [.pink, .orange, .purple, .blue, .gray]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<favorites.count, id: \.self) { index in
                    VStack {
                        Circle()
                            .fill(colors[index].gradient)
                            .frame(width: 60, height: 60)
                            .overlay(Text(String(favorites[index].prefix(1))).foregroundColor(.white).bold())
                        Text(favorites[index])
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}
