import SwiftUI

struct UserStatusView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var isEditingMood = false // 是否正在編輯心情

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 15) {
                // 大頭貼
                Circle()
                    .fill(locationManager.userProfile.avatarColor.gradient)
                    .frame(width: 60, height: 60)
                    .overlay(Text("B").font(.title).bold().foregroundColor(.white))
                    .shadow(radius: 5)

                VStack(alignment: .leading, spacing: 4) {
                    Text(locationManager.userProfile.name)
                        .font(.title3).bold()
                    
                    HStack(spacing: 8) {
                        // 電量顯示
                        Label("\(locationManager.batteryLevel)%", systemImage: batteryIcon(for: locationManager.batteryLevel))
                            .font(.caption).bold()
                            .foregroundColor(locationManager.batteryLevel < 20 ? .red : .green)
                        
                        // 當前位置
                        Label(locationManager.userAddress, systemImage: "location.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // 心情小語區塊
            HStack {
                Image(systemName: "quote.opening")
                    .foregroundColor(.blue)
                
                Text(locationManager.userProfile.mood)
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.primary.opacity(0.8))
                
                Spacer()
                
                Button(action: { isEditingMood.toggle() }) {
                    Image(systemName: "pencil.line")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(12)
            .background(Color.blue.opacity(0.05))
            .cornerRadius(12)
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        // 編輯心情的彈窗
        .alert("更新心情小語", isPresented: $isEditingMood) {
            TextField("在想什麼呢？", text: $locationManager.userProfile.mood)
            Button("確定", role: .cancel) { }
        }
    }
    
    private func batteryIcon(for level: Int) -> String {
        level < 20 ? "battery.25" : (level < 70 ? "battery.75" : "battery.100")
    }
}
