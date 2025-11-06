//
//  UserDefaultsManager.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import Foundation
import Combine

/// アプリケーション全体の永続化データを管理するクラス
class UserDefaultsManager: ObservableObject {
    // MARK: - シングルトンインスタンス
    static let shared = UserDefaultsManager()

    // MARK: - 公開プロパティ
    /// 保存されているテスト結果一覧
    @Published var testResults: [TestResult] = []

    /// 現在設定されているテストのセット数
    @Published var testSetsCount: Int = DefaultValues.testSetsCount

    // MARK: - 定数
    /// UserDefaultsのキー
    private enum Keys {
        static let testResults = "testResults"
        static let testSetsCount = "testSetsCount"
        static let isFirstLaunchCompleted = "isFirstLaunchCompleted"
        static let shouldShowTutorial = "shouldShowTutorial"
    }

    /// デフォルト値
    private enum DefaultValues {
        static let testSetsCount = 15
        static let minSetsCount = 1
        static let maxSetsCount = 15
    }

    // MARK: - 初期化
    private init() {
        loadTestResults()

        // UserDefaultsからセット数を読み込む
        testSetsCount = getTestSetsCount()
    }

    // MARK: - 公開メソッド

    /// アプリ初回起動時の初期化処理
    func initializeUserDefaults() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: Keys.isFirstLaunchCompleted)

        if !isFirstLaunch {
            // 初回起動時の処理
            setInitialDefaults()
        }
    }

    /// テストのセット数を取得
    /// - Returns: 有効範囲内のセット数（1〜15）
    func getTestSetsCount() -> Int {
        let count = UserDefaults.standard.integer(forKey: Keys.testSetsCount)

        // 有効範囲外またはデフォルト値の場合はデフォルト値を返す
        if count < DefaultValues.minSetsCount || count > DefaultValues.maxSetsCount || count == 0 {
            return DefaultValues.testSetsCount
        }

        return count
    }

    /// テストのセット数を保存
    /// - Parameter count: 保存するセット数
    func saveTestSetsCount(_ count: Int) {
        // 有効範囲内に制限
        let validCount = min(max(count, DefaultValues.minSetsCount), DefaultValues.maxSetsCount)

        UserDefaults.standard.set(validCount, forKey: Keys.testSetsCount)
        UserDefaults.standard.synchronize()

        // 公開プロパティを更新
        testSetsCount = validCount
    }

    /// テスト結果を追加
    /// - Parameter result: 追加するテスト結果
    func addTestResult(_ result: TestResult) {
        testResults.append(result)
        saveTestResults()
    }

    /// 指定位置のテスト結果を削除
    /// - Parameter offsets: 削除する位置のインデックスセット
    func deleteTestResults(at offsets: IndexSet) {
        testResults.remove(atOffsets: offsets)
        saveTestResults()
    }

    /// 全てのテスト結果を削除
    func clearAllTestResults() {
        testResults = []
        saveTestResults()
    }

    // MARK: - プライベートメソッド

    /// 初回起動時のデフォルト値を設定
    private func setInitialDefaults() {
        UserDefaults.standard.set(true, forKey: Keys.isFirstLaunchCompleted)
        UserDefaults.standard.set(true, forKey: Keys.shouldShowTutorial)
        UserDefaults.standard.set(DefaultValues.testSetsCount, forKey: Keys.testSetsCount)
        UserDefaults.standard.synchronize()
    }

    /// テスト結果をUserDefaultsから読み込む
    private func loadTestResults() {
        guard let data = UserDefaults.standard.data(forKey: Keys.testResults) else {
            testResults = []
            return
        }

        do {
            let decoder = JSONDecoder()
            testResults = try decoder.decode([TestResult].self, from: data)
        } catch {
            handleLoadError(error)
        }
    }

    /// テスト結果をUserDefaultsに保存
    private func saveTestResults() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(testResults)
            UserDefaults.standard.set(data, forKey: Keys.testResults)
            UserDefaults.standard.synchronize()
        } catch {
            handleSaveError(error)
        }
    }

    /// 読み込みエラーの処理
    /// - Parameter error: 発生したエラー
    private func handleLoadError(_ error: Error) {
        // ログ記録
        print("テスト結果の読み込みに失敗しました: \(error.localizedDescription)")

        // リカバリー処理：空の配列を使用
        testResults = []

        // 必要に応じてエラー通知などの追加処理をここに実装
    }

    /// 保存エラーの処理
    /// - Parameter error: 発生したエラー
    private func handleSaveError(_ error: Error) {
        // ログ記録
        print("テスト結果の保存に失敗しました: \(error.localizedDescription)")

        // 必要に応じてエラー通知などの追加処理をここに実装
    }
}
