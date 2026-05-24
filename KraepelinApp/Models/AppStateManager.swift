//
//  AppStateManager.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

/// アプリの画面状態を表す列挙型
enum AppScreen {
    case home
    case tutorial
    case testStart
    case countdown
    case test
    case history
    case settings
    case detail

    /// 画面のタイトルを返す
    var title: String {
        switch self {
        case .home: return "ホーム"
        case .tutorial: return "チュートリアル"
        case .testStart: return "テスト開始"
        case .countdown: return "カウントダウン"
        case .test: return "テスト"
        case .history: return "履歴"
        case .settings: return "設定"
        case .detail: return "詳細"
        }
    }
}

/// アプリの状態管理を担当するクラス
class AppStateManager: ObservableObject {
    /// シングルトンインスタンス
    static let shared = AppStateManager()

    /// アプリの現在の画面
    @Published var activeScreen: AppScreen = .home

    /// 詳細表示する検査結果のID
    @Published var lastResultId: UUID?
}
