import Foundation
import CoreLocation
import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let avatarColor: Color
    let lastUpdated: Date
    
    // 🌟 新增的豐富屬性
    var batteryLevel: Int
    var status: String
}

// 豐富版的模擬資料
let mockFriends: [Friend] = [
    Friend(name: "女友",
           coordinate: CLLocationCoordinate2D(latitude: 24.7745, longitude: 121.0150),
           avatarColor: .pink,
           lastUpdated: Date().addingTimeInterval(-120),
           batteryLevel: 85,
           status: "在科學園區"),
    
    Friend(name: "老爸",
           coordinate: CLLocationCoordinate2D(latitude: 24.8036, longitude: 120.9686),
           avatarColor: .orange,
           lastUpdated: Date().addingTimeInterval(-1200),
           batteryLevel: 42,
           status: "靜止中"),
    
    Friend(name: "老媽",
           coordinate: CLLocationCoordinate2D(latitude: 24.7950, longitude: 120.9950),
           avatarColor: .purple,
           lastUpdated: Date().addingTimeInterval(-60),
           batteryLevel: 98,
           status: "移動中")
]
