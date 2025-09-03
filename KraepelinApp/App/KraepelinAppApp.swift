//
//  KraepelinAppApp.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

@main
struct KraepelinAppApp: App {
    // アプリケーション全体の状態管理
    @StateObject private var userDefaultsManager = UserDefaultsManager.shared
    @StateObject private var appStateManager = AppStateManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStateManager)
                .onAppear {
                    // アプリ起動時のUserDefaultsの初期設定
                    UserDefaultsManager.shared.initializeUserDefaults()
                }
        }
    }
}
