//
//  CountdownView.swift
//  KraepelinApp
//
//  Created on 2025/04/16.
//

import SwiftUI

struct CountdownView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @State private var countdown = 3
    @State private var isAnimating = false
    @State private var showStart = false

    private let startText = "始め"

    var body: some View {
        ZStack {
            // 背景色
            AppColor.background.edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text(showStart ? "" : "検査が始まります")
                    .font(.title)
                    .fontWeight(.bold)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)

                // カウントダウンとスタートテキストの表示
                if showStart {
                    Text(startText)
                        .font(.system(size: 70, weight: .bold))
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: isAnimating)
                } else {
                    Text("\(countdown)")
                        .font(.system(size: 100, weight: .bold))
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: isAnimating)
                }
            }
            .padding()
            .foregroundColor(AppColor.primary)
            .onAppear {
                // 数字が拡大・縮小するアニメーション
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                    isAnimating.toggle()
                }
            }
        }
        .task {
            await runCountdown()
        }
    }

    /// 3 → 2 → 1 → 「始め」と進み、最後にテスト画面へ遷移する
    private func runCountdown() async {
        for next in [2, 1] {
            try? await Task.sleep(for: .seconds(1))
            countdown = next
        }
        try? await Task.sleep(for: .seconds(1))
        showStart = true
        try? await Task.sleep(for: .seconds(1))
        appStateManager.activeScreen = .test
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
            .environmentObject(AppStateManager.shared)
    }
}
