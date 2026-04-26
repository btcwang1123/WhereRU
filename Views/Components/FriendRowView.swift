import SwiftUI

struct FriendRowView: View {
    let friend: Friend
    let onNotifyTapped: () -> Void
    let onRouteTapped: () -> Void // 🌟 新增：規劃路線的動作
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(friend.avatarColor.gradient)
                    .frame(width: 50, height: 50)
                    .overlay(Text(String(friend.name.prefix(1))).font(.title3).bold().foregroundColor(.white))
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 14, height: 14)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .offset(x: 2, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name).font(.headline)
                HStack {
                    Image(systemName: friend.status == "移動中" ? "figure.walk" : "mappin.and.ellipse")
                    Text(friend.status)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Text(friend.lastUpdated.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            // 🌟 將按鈕改成橫向排列
            HStack(spacing: 12) {
                // 路線導航按鈕
                Button(action: onRouteTapped) {
                    Image(systemName: "car.fill")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.green.gradient)
                        .clipShape(Circle())
                }
                .buttonStyle(.borderless)
                
                // 圍欄鈴鐺按鈕
                Button(action: onNotifyTapped) {
                    Image(systemName: "bell.badge.fill")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue.gradient)
                        .clipShape(Circle())
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical, 6)
    }
}
