//
//  TestViewModel.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import Foundation
import SwiftUI
import Combine

/// クレペリン検査のビジネスロジックを管理するViewModel
class TestViewModel: ObservableObject {
    // MARK: - 公開プロパティ

    /// 現在表示中の数字列（5行分）
    @Published var currentNumbers: [[Int]] = []

    /// 現在の行インデックス（絶対位置）
    @Published var currentRowIndex: Int = 0

    /// 現在の列インデックス（各行内での位置）
    @Published var currentColumnIndex: Int = 0

    /// 最後にユーザーが入力した数字
    @Published var lastInput: Int? = nil

    /// 現在のセットインデックス（0から始まる）
    @Published var currentSetIndex: Int = 0

    /// 検査が完了したかどうかのフラグ
    @Published var isTestComplete: Bool = false

    /// ユーザーの回答履歴を保存する2次元配列
    @Published var answerHistory: [[Int?]] = []

    /// 表示開始行のオフセット（スクロール用）
    @Published var displayOffset: Int = 0

    // MARK: - 設定値とパラメータ
    /// 検査の総セット数（UserDefaultsから取得）
    var totalSets: Int {
        return userDefaultsManager.getTestSetsCount()
    }

    /// 各セットの制限時間（秒）
    private let setDuration: TimeInterval

    /// 表示する行数
    private let displayRowCount: Int = 5

    /// 各行の数字列の長さ（元の設定に戻す）
    private let rowLength: Int

    /// 生成する数字の範囲
    private let numberRange: ClosedRange<Int>

    // MARK: - コールバックとデータストア

    /// セット完了時のコールバック
    var onSetComplete: (() -> Void)?

    /// UserDefaultsアクセス用マネージャー
    private let userDefaultsManager: UserDefaultsManagerProtocol

    // MARK: - 内部状態管理

    /// タイマー
    private var timer: Timer?

    /// タイマー開始時刻
    private var startTime: Date?

    /// 正解数
    private var correctAnswers: Int = 0

    /// 回答総数
    private var totalAnswers: Int = 0

    /// 各セットの正答率
    private var setResults: [Double] = []

    /// 各セットの正解数
    private var setCorrectCounts: [Int] = []

    /// 各セットの問題数
    private var setTotalCounts: [Int] = []

    // MARK: - 計算プロパティ

    /// 現在表示中の5行のデータを取得
    var displayRows: [[Int]] {
        let startRow = displayOffset
        let endRow = min(displayOffset + displayRowCount, currentNumbers.count)
        return Array(currentNumbers[startRow..<endRow])
    }

    /// 現在表示中の5行の解答履歴を取得
    var displayAnswerHistory: [[Int?]] {
        let startRow = displayOffset
        let endRow = min(displayOffset + displayRowCount, answerHistory.count)
        return Array(answerHistory[startRow..<endRow])
    }

    /// 表示座標系での現在位置
    var displayCurrentRowIndex: Int {
        return currentRowIndex - displayOffset
    }

    // MARK: - 初期化と終了処理

    /// 初期化
    /// - Parameters:
    ///   - userDefaultsManager: UserDefaultsマネージャー（テスト時に差し替え可能）
    ///   - setDuration: 1セットあたりの制限時間（秒）
    ///   - rowLength: 各行の数字列の長さ（元の設定116に戻す）
    ///   - numberRange: 生成する数字の範囲
    init(userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager.shared,
         setDuration: TimeInterval = 5,
         rowLength: Int = 116,
         numberRange: ClosedRange<Int> = 3...9) {

        self.userDefaultsManager = userDefaultsManager
        self.setDuration = setDuration
        self.rowLength = rowLength
        self.numberRange = numberRange

        generateInitialNumbers()
    }

    /// デイニシャライザ - タイマーを確実に破棄
    deinit {
        stopTimer()
    }

    // MARK: - 公開メソッド

    /// 検査を開始する
    func startTest() {
        resetTestData()
        isTestComplete = false
        startTimer()
    }

    /// 次のセットへ移動する
    func moveToNextSet() {
        // 現在のセットの結果を保存
        saveCurrentSetResult()

        // 次のセットへ
        currentSetIndex += 1

        // 完了判定
        if currentSetIndex >= totalSets {
            isTestComplete = true
            return
        }

        // セット間では数字列はリセットしない！
        // ただし、マーカーは次の行の最初に移動
        moveToNextRowStart()

        // セットのカウンターのみリセット
        resetCurrentSetCounters()

        // タイマー再開
        startTimer()
    }

    /// ユーザーの回答を処理する
    /// - Parameter number: ユーザーが入力した数字
    func inputAnswer(_ number: Int) {
        // 入力可能な状態かチェック
        guard canAcceptInput() else { return }

        // 入力を記録
        lastInput = number

        // 解答履歴に保存
        ensureAnswerHistoryCapacity()
        answerHistory[currentRowIndex][currentColumnIndex] = number

        // 正誤判定
        processAnswer(number)

        // 次の問題へ進む
        moveToNextProblem()
    }

    /// 現在のセットの結果を保存する
    func saveCurrentSetResult() {
        let (accuracy, corrects, total) = calculateCurrentSetResults()

        setResults.append(accuracy)
        setCorrectCounts.append(corrects)
        setTotalCounts.append(total)

        logResults(setIndex: currentSetIndex, accuracy: accuracy, corrects: corrects, total: total)
    }

    /// 検査結果を生成する
    /// - Returns: 検査結果オブジェクト
    func generateTestResult() -> TestResult {
        // タイマーを停止
        stopTimer()

        // 結果が揃っていない場合は足りないセットを埋める
        ensureCompleteResults()

        // 全体の正答率を計算
        let overallAccuracy = calculateOverallAccuracy()

        // 結果オブジェクトを生成して返す
        return createTestResultObject(overallAccuracy: overallAccuracy)
    }

    // MARK: - 内部ヘルパーメソッド

    /// 検査データを完全にリセットする（テスト開始時のみ）
    private func resetTestData() {
        currentSetIndex = 0
        currentRowIndex = 0
        currentColumnIndex = 0
        displayOffset = 0
        lastInput = nil
        setResults = []
        setCorrectCounts = []
        setTotalCounts = []
        resetCurrentSetCounters()
        generateInitialNumbers()
    }

    /// 現在のセットのカウンターのみリセット（数字列はそのまま）
    private func resetCurrentSetCounters() {
        correctAnswers = 0
        totalAnswers = 0
    }

    /// 入力を受け付けられる状態かどうかを判定
    /// - Returns: 入力可能な場合はtrue
    private func canAcceptInput() -> Bool {
        return timer != nil &&
               currentRowIndex < currentNumbers.count &&
               currentColumnIndex < rowLength - 1
    }

    /// ユーザーの回答を処理する
    /// - Parameter answer: ユーザーの回答
    private func processAnswer(_ answer: Int) {
        // 正解を計算
        let correctAnswer = calculateCorrectAnswer()

        // 正誤判定
        if answer == correctAnswer {
            correctAnswers += 1
        }

        // 総回答数カウント
        totalAnswers += 1
    }

    /// 正解を計算する
    /// - Returns: 正解の数字
    private func calculateCorrectAnswer() -> Int {
        let currentNum = currentNumbers[currentRowIndex][currentColumnIndex]
        let nextNum = currentNumbers[currentRowIndex][currentColumnIndex + 1]
        return (currentNum + nextNum) % 10
    }

    /// 次の行の最初に移動する
    private func moveToNextRowStart() {
        currentColumnIndex = 0
        currentRowIndex += 1

        // 新しい行が必要かチェック
        ensureRowExists(currentRowIndex)

        // スクロールが必要かチェック
        checkScrollNeeded()
    }

    /// 次の問題へ移動する
    private func moveToNextProblem() {
        currentColumnIndex += 1

        // 行の最後まで到達したら次の行へ
        if currentColumnIndex >= rowLength - 1 {
            currentColumnIndex = 0
            currentRowIndex += 1

            // 新しい行が必要かチェック
            ensureRowExists(currentRowIndex)

            // スクロールが必要かチェック
            checkScrollNeeded()
        }
    }

    /// 指定した行が存在することを保証する
    private func ensureRowExists(_ rowIndex: Int) {
        while currentNumbers.count <= rowIndex {
            addNewRow()
        }
    }

    /// 新しい行を追加する
    private func addNewRow() {
        let newRow = (0..<rowLength).map { _ in Int.random(in: numberRange) }
        currentNumbers.append(newRow)

        // 解答履歴も拡張
        answerHistory.append(Array(repeating: nil, count: rowLength))
    }

    /// スクロールが必要かチェックして実行
    private func checkScrollNeeded() {
        // 現在の行が表示範囲を超えた場合はスクロール
        if currentRowIndex >= displayOffset + displayRowCount {
            displayOffset = currentRowIndex - displayRowCount + 1
        }
    }

    /// 解答履歴の容量を確保する
    private func ensureAnswerHistoryCapacity() {
        // 行数が足りない場合は追加
        while answerHistory.count <= currentRowIndex {
            answerHistory.append(Array(repeating: nil, count: rowLength))
        }
    }

    /// 初期の数字列を生成する
    private func generateInitialNumbers() {
        currentNumbers = []
        answerHistory = []

        // 初期表示用に5行分を生成
        for _ in 0..<displayRowCount {
            let row = (0..<rowLength).map { _ in Int.random(in: numberRange) }
            currentNumbers.append(row)
            answerHistory.append(Array(repeating: nil, count: rowLength))
        }
    }

    /// 現在のセットの結果を計算する
    /// - Returns: (正答率, 正解数, 問題数)のタプル
    private func calculateCurrentSetResults() -> (Double, Int, Int) {
        if totalAnswers > 0 {
            let accuracy = Double(correctAnswers) / Double(totalAnswers)
            return (accuracy, correctAnswers, totalAnswers)
        } else {
            return (0.0, 0, 0)
        }
    }

    /// 結果をログ出力する
    private func logResults(setIndex: Int, accuracy: Double, corrects: Int, total: Int) {
        print("セット(\(setIndex))の正答率: \(accuracy), 正解数: \(corrects)/\(total)")
    }

    /// 不足している結果データを埋める
    private func ensureCompleteResults() {
        while setResults.count < totalSets {
            setResults.append(0.0)
            setCorrectCounts.append(0)
            setTotalCounts.append(0)
        }

        print("検査結果 - セット数: \(setResults.count), 各セットの正答率: \(setResults)")
    }

    /// 全体の正答率を計算する
    /// - Returns: 全体の正答率
    private func calculateOverallAccuracy() -> Double {
        if setResults.isEmpty {
            return 0.0
        }

        let totalAccuracy = setResults.reduce(0.0, +) / Double(setResults.count)
        return totalAccuracy
    }

    /// 検査結果オブジェクトを作成する
    /// - Parameter overallAccuracy: 全体の正答率
    /// - Returns: 検査結果オブジェクト
    private func createTestResultObject(overallAccuracy: Double) -> TestResult {
        return TestResult(
            id: UUID(),
            date: Date(),
            overallAccuracy: overallAccuracy,
            setAccuracies: setResults,
            correctCounts: setCorrectCounts,
            totalCounts: setTotalCounts
        )
    }

    // MARK: - タイマー管理

    /// タイマーを開始する
    private func startTimer() {
        startTime = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }

            let elapsedTime = Date().timeIntervalSince(startTime)

            // 設定時間が経過したらタイマーを停止し、次のセットへ
            if elapsedTime >= self.setDuration {
                self.stopTimer()
                self.onSetComplete?()
            }
        }
    }

    /// タイマーを停止する
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - プロトコル定義

/// UserDefaultsManager用プロトコル（テスト容易性のため）
protocol UserDefaultsManagerProtocol {
    func getTestSetsCount() -> Int
    func addTestResult(_ result: TestResult)
}

// MARK: - 既存のUserDefaultsManagerに準拠を追加

extension UserDefaultsManager: UserDefaultsManagerProtocol {}
