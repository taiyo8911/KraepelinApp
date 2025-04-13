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

    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
                    // UserDefaultsの初期化
                    UserDefaultsManager.shared.initializeUserDefaults()
                }
        }
    }
}
