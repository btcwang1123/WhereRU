import SwiftUI
import AuthenticationServices

struct LoginView: View {
    // 使用 AppStorage 把登入狀態存在手機本地
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("appleUserId") var appleUserId = ""

    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            
            // App Logo 與 標語
            VStack(spacing: 16) {
                Image(systemName: "location.magnifyingglass")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .symbolEffect(.pulse)
                Text("WhereRU")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                Text("安全連線，守護家人")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 🌟 蘋果原生登入按鈕
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    // 第一次登入時，向使用者請求姓名與信箱
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        handleAppleLogin(authorization: authorization)
                    case .failure(let error):
                        print("登入授權失敗：\(error.localizedDescription)")
                    }
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 55)
            .cornerRadius(100)
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
    
    // 處理登入成功後的資料
    private func handleAppleLogin(authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            self.appleUserId = appleIDCredential.user
            
            // 🌟 印出 JWT 給 Postman 測試用
            if let identityTokenData = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("\n=======================================")
                print("🍎 成功取得 Apple Identity Token！")
                print("請複製下方這長串 JWT，貼到 Postman 的 API 請求中：\n")
                print(identityTokenString)
                print("=======================================\n")
            }
            
            withAnimation(.easeInOut) {
                isLoggedIn = true
            }
        }
    }
}
