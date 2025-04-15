//
//  ContentView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//


import SwiftUI

// メインコンテンツビュー（画面遷移の管理）
struct ContentView: View {
    @EnvironmentObject var appStateManager: AppStateManager

    var body: some View {
        NavigationView {
            // 現在のアクティブ画面に基づいて表示する画面を切り替え
            switch appStateManager.activeScreen {
            case .home:
                HomeView()
            case .tutorial:
                TutorialView()
            case .testStart:
                TestStartView()
            case .countdown:
                CountdownView()
            case .test:
                TestView()
                    .environmentObject(TestViewModel())
            case .history:
                HistoryView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppStateManager.shared)
    }
}
