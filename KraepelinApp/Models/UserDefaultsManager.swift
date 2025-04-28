//
//  UserDefaultsManager.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import Foundation
import Combine

class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()

    @Published var testResults: [TestResult] = []

    private let testResultsKey = "testResults"

    // セット数のキー
    private let testSetsCountKey = "testSetsCount"

    // セット数を取得するメソッド（3-15の範囲内で）
    func getTestSetsCount() -> Int {
        let count = UserDefaults.standard.integer(forKey: testSetsCountKey)
        if count < 3 || count > 15 || count == 0 {
            return 15  // デフォルト値
        }
        return count
    }

    // セット数を保存するメソッド
    func saveTestSetsCount(_ count: Int) {
        let validCount = min(max(count, 3), 15)  // 3-15の範囲に制限
        UserDefaults.standard.set(validCount, forKey: testSetsCountKey)
        UserDefaults.standard.synchronize()
    }

    // デフォルトのセット数
    private let defaultTestSetsCount = 15

    // 現在のセット数（3-15の範囲）
    @Published var testSetsCount: Int = 15

    private init() {
        loadTestResults()
    }

    // UserDefaultsの初期化メソッドを追加
    func initializeUserDefaults() {
        // 初期化が必要な場合はここで処理
        // 例：初回起動時のフラグを設定する、デフォルト設定を保存するなど
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunchCompleted")

        if !isFirstLaunch {
            // 初回起動時の処理
            // 例：チュートリアルを表示するフラグを立てるなど
            UserDefaults.standard.set(true, forKey: "isFirstLaunchCompleted")
            UserDefaults.standard.set(true, forKey: "shouldShowTutorial")

            // その他の初期設定
            // UserDefaults.standard.set(defaultValue, forKey: "someKey")

            // 変更を保存
            UserDefaults.standard.synchronize()

            // セット数を読み込む（なければデフォルト値を使用）
            testSetsCount = UserDefaults.standard.integer(forKey: testSetsCountKey)
            if testSetsCount == 0 || testSetsCount < 3 || testSetsCount > 15 {
                testSetsCount = defaultTestSetsCount
                UserDefaults.standard.set(testSetsCount, forKey: testSetsCountKey)
            }
        }
    }

    private func loadTestResults() {
        if let data = UserDefaults.standard.data(forKey: testResultsKey) {
            do {
                let decoder = JSONDecoder()
                testResults = try decoder.decode([TestResult].self, from: data)
            } catch {
                print("テスト結果の読み込みに失敗しました: \(error.localizedDescription)")
                // 読み込みに失敗した場合は空の配列を使用
                testResults = []
            }
        }
    }

    func saveTestResults() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(testResults)
            UserDefaults.standard.set(data, forKey: testResultsKey)
        } catch {
            print("テスト結果の保存に失敗しました: \(error.localizedDescription)")
        }
    }

    func addTestResult(_ result: TestResult) {
        testResults.append(result)
        saveTestResults()
    }

    func deleteTestResults(at offsets: IndexSet) {
        testResults.remove(atOffsets: offsets)
        saveTestResults()
    }

    func clearAllTestResults() {
        testResults = []
        saveTestResults()
    }
}
