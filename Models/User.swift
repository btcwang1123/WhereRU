import Foundation
import SwiftUI

struct UserProfile {
    var name: String = "Bobby Wang"
    var mood: String = "今天天氣不錯，來寫 Code 吧！"
    var avatarColor: Color = .blue
    // 其他如電池、位置等資訊會從 LocationManager 即時取得
}
