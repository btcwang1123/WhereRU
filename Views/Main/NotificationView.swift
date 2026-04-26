import SwiftUI

// 1. 定義通知類型，方便區分視覺風格
enum NotificationType {
    case location, battery, security, alert
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let type: NotificationType
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    let time: String
    let personName: String
}

struct NotificationView: View {
    @State private var selectedFilter = 0
    private let filters = ["全部", "位置", "安全"]
    
    // 模擬更豐富的資料
    @State private var notifications = [
        NotificationItem(type: .location, icon: "figure.walk.circle.fill", color: .green, title: "已抵達 公司", subtitle: "新竹科學園區", time: "09:05", personName: "女友"),
        NotificationItem(type: .battery, icon: "battery.25", color: .red, title: "手機電量極低 (15%)", subtitle: "建議提醒他充電", time: "08:30", personName: "老爸"),
        NotificationItem(type: .security, icon: "exclamationmark.shield.fill", color: .orange, title: "關閉了位置分享", subtitle: "最後位置：竹北家裡", time: "昨天", personName: "老爸"),
        NotificationItem(type: .location, icon: "house.circle.fill", color: .blue, title: "已離開 家裡", subtitle: "前往：台北市", time: "昨天", personName: "老媽"),
        NotificationItem(type: .alert, icon: "location.slash.fill", color: .gray, title: "訊號不穩定", subtitle: "無法取得精準位置", time: "2天前", personName: "老媽")
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 亮點 A: 分類切換器
                Picker("篩選通知", selection: $selectedFilter) {
                    ForEach(0..<filters.count, id: \.self) { index in
                        Text(filters[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .background(Color(uiColor: .systemGroupedBackground))

                List {
                    Section {
                        ForEach(notifications) { notif in
                            RichNotifRow(notif: notif)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        // 刪除通知
                                    } label: {
                                        Label("刪除", systemImage: "trash")
                                    }
                                }
                        }
                    } header: {
                        Text("最近活動")
                    }
                }
                .listStyle(.plain) // 使用 Plain Style 搭配自定義 Row 更有科技感
            }
            .navigationTitle("活動通知")
            //.safeAreaPadding(.leading, 60) // 保持你原有的左側導覽空間
            .toolbar {
                Button("全部已讀") {
                    // 已讀邏輯
                }
            }
        }
    }
}

// 2. 豐富的通知行元件
struct RichNotifRow: View {
    let notif: NotificationItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // 左側 Icon 與垂直線條設計 (Timeline 感)
            VStack {
                ZStack {
                    Circle()
                        .fill(notif.color.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: notif.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(notif.color)
                }
                
                // 這裡可以視需求加入細連線
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(width: 2)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    // 強調人名
                    Text(notif.personName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(notif.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(notif.time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                if !notif.subtitle.isEmpty {
                    Text(notif.subtitle)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(6)
                        .foregroundColor(.secondary)
                }
                
                // 亮點 B: 快速操作按鈕 (僅在特定類型顯示)
                if notif.type == .battery || notif.type == .security {
                    HStack {
                        Button(action: {}) {
                            Label("撥打電話", systemImage: "phone.fill")
                                .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .tint(notif.color)
                        .controlSize(.small)
                        
                        Button(action: {}) {
                            Label("傳送訊息", systemImage: "message.fill")
                                .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .tint(.gray)
                        .controlSize(.small)
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.bottom, 8)
        }
        .listRowSeparator(.hidden) // 隱藏原生分隔線，使用自定義間距
        .padding(.vertical, 4)
    }
}
