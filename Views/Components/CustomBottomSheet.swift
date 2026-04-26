import SwiftUI

enum SheetState { case collapsed, half, full }

struct CustomBottomSheet<Header: View, Content: View>: View {
    @Binding var state: SheetState
    let header: Header
    let content: Content
    
    init(state: Binding<SheetState>, @ViewBuilder header: () -> Header, @ViewBuilder content: () -> Content) {
        self._state = state
        self.header = header()
        self.content = content()
    }

    var body: some View {
        GeometryReader { proxy in
            let fullHeight = proxy.size.height
            let currentOffset = offset(for: state, in: fullHeight)

            VStack(spacing: 0) {
                // 把手與 Header
                VStack(spacing: 0) {
                    Capsule().fill(Color.gray.opacity(0.4)).frame(width: 40, height: 5).padding(.vertical, 10)
                    header
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture().onEnded { value in
                        let threshold: CGFloat = 30
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if value.translation.height < -threshold {
                                if state == .collapsed { state = .half } else { state = .full }
                            } else if value.translation.height > threshold {
                                if state == .full { state = .half } else { state = .collapsed }
                            }
                        }
                    }
                )
                
                // 內容區塊
                content.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: proxy.size.width, height: fullHeight)
            .background(.regularMaterial)
            .clipShape(.rect(topLeadingRadius: 24, topTrailingRadius: 24))
            .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            .offset(y: currentOffset)
        }
    }
    
    // 計算抽屜高度
    private func offset(for state: SheetState, in height: CGFloat) -> CGFloat {
        switch state {
        case .collapsed: return height * 0.75 // 縮小到下方
        case .half: return height * 0.4
        case .full: return height * 0.1
        }
    }
}
