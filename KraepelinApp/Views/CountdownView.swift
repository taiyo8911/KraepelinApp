//
//  CountdownView.swift
//  KraepelinApp
//
//  Created on 2025/04/16.
//

import SwiftUI

struct CountdownView: View {
    @EnvironmentObject var appStateManager: AppStateManager // アプリの状態管理
    @State private var countdown = 3 // カウントダウンの初期値
    @State private var isAnimating = false // アニメーションの状態
    @State private var showStart = false // 「はじめ」の表示状態
    @State private var startText = "はじめ" // 表示するテキスト

    // タイマー
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // 背景色
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text(showStart ? "" : "検査が始まります")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)

                // カウントダウンとスタートテキストの表示
                if showStart {
                    Text("\(startText)")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.blue)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: isAnimating)
                } else {
                    Text("\(countdown)")
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(.blue)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: isAnimating)
                }
            }
            .padding()
            .onAppear {
                // 数字が拡大・縮小するアニメーション
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                    isAnimating.toggle()
                }
            }
        }
        // タイマーの開始
        .onReceive(timer) { _ in
            if countdown > 1 {
                countdown -= 1
            } else if countdown == 1 {
                countdown -= 1
                showStart = true
            } else if showStart {
                // タイマーをキャンセル
                timer.upstream.connect().cancel()

                // スタートテキストの表示後、テスト画面へ遷移
                appStateManager.activeScreen = .test
            }
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
            .environmentObject(AppStateManager.shared)
    }
}
