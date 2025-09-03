////
////  AppStateManager.swift
////  KraepelinApp
////
////  Created by Taiyo KOSHIBA on 2025/04/13.
////
//
//import SwiftUI
//
//class AppStateManager: ObservableObject {
//    static let shared = AppStateManager()
//    
//    // アプリの画面遷移状態
//    @Published var activeScreen: ActiveScreen = .home
//
//    // 最後に表示した検査結果のID（詳細画面で使用）
//    @Published var lastResultId: UUID?
//
//    // 検査終了後に保存すべき結果
//    private var pendingTestResult: TestResult?
//    
//    // 画面遷移をホームに戻す
//    func returnToHome() {
//        // 保存すべき結果があれば保存する
//        if let result = pendingTestResult {
//            UserDefaultsManager.shared.addTestResult(result)
//            pendingTestResult = nil
//        }
//        
//        // ホーム画面に戻す
//        activeScreen = .home
//    }
//    
//    // テスト結果を保存予約
//    func saveTestResult(_ result: TestResult) {
//        pendingTestResult = result
//    }
//}
//
//// アプリの画面状態
//enum ActiveScreen {
//    case home
//    case tutorial
//    case testStart
//    case countdown
//    case test
//    case history
//    case settings
//    case detail
//}


//
//  AppStateManager.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI
import Combine

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

/// テスト結果の保存インターフェース
protocol TestResultStorage {
    func saveTestResult(_ result: TestResult)
}

/// UserDefaultsを使用したテスト結果の保存実装
class UserDefaultsResultStorage: TestResultStorage {
    func saveTestResult(_ result: TestResult) {
        UserDefaultsManager.shared.addTestResult(result)
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

    /// 保存待ちの検査結果
    private var pendingTestResult: TestResult?

    /// テスト結果の保存を担当するストレージ
    private let resultStorage: TestResultStorage

    /// イニシャライザ
    /// - Parameter storage: テスト結果ストレージ（デフォルトはUserDefaultsResultStorage）
    init(storage: TestResultStorage = UserDefaultsResultStorage()) {
        self.resultStorage = storage
    }

    /// ホーム画面に戻る
    /// 保存待ちの検査結果があれば保存してからホーム画面に遷移する
    func returnToHome() {
        savePendingResultIfNeeded()
        activeScreen = .home
    }

    /// 保存待ちの検査結果があれば保存する
    private func savePendingResultIfNeeded() {
        if let result = pendingTestResult {
            resultStorage.saveTestResult(result)
            pendingTestResult = nil
        }
    }

    /// テスト結果を保存予約する
    /// - Parameter result: 保存するテスト結果
    func saveTestResult(_ result: TestResult) {
        pendingTestResult = result
    }

    /// 詳細表示する検査結果のIDを設定し、詳細画面に遷移する
    /// - Parameter resultId: 表示する検査結果のID
    func showResultDetails(for resultId: UUID) {
        lastResultId = resultId
        activeScreen = .detail
    }

    /// 指定した画面に遷移する
    /// - Parameter screen: 遷移先の画面
    func navigateTo(_ screen: AppScreen) {
        activeScreen = screen
    }
}
