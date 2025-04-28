//
//  AppStateManager.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

class AppStateManager: ObservableObject {
    static let shared = AppStateManager()
    
    // アプリの画面遷移状態
    @Published var activeScreen: ActiveScreen = .home

    // 最後に表示した検査結果のID（詳細画面で使用）
    @Published var lastResultId: UUID?

    // 検査終了後に保存すべき結果
    private var pendingTestResult: TestResult?
    
    // 画面遷移をホームに戻す
    func returnToHome() {
        // 保存すべき結果があれば保存する
        if let result = pendingTestResult {
            UserDefaultsManager.shared.addTestResult(result)
            pendingTestResult = nil
        }
        
        // ホーム画面に戻す
        activeScreen = .home
    }
    
    // テスト結果を保存予約
    func saveTestResult(_ result: TestResult) {
        pendingTestResult = result
    }
}

// アプリの画面状態
enum ActiveScreen {
    case home
    case tutorial
    case testStart
    case countdown
    case test
    case history
    case settings
    case detail
}
