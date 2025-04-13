//
//  KraepelinAppApp.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

@main
struct KraepelinAppApp: App {
    // アプリの状態管理
    @StateObject private var userDefaultsManager = UserDefaultsManager.shared
    @StateObject private var appStateManager = AppStateManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStateManager)
                .onAppear {
                    // UserDefaultsの初期化
                    UserDefaultsManager.shared.initializeUserDefaults()
                }
        }
    }
}
