//
//  TestViewModel.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//


import Foundation
import SwiftUI
import Combine

class TestViewModel: ObservableObject {
    // 検査関連のプロパティ
    @Published var currentNumbers: [Int] = []
    @Published var currentIndex: Int = 0
    @Published var lastInput: Int? = nil
    @Published var currentSetIndex: Int = 0

    // 検査完了フラグ
    @Published var isTestComplete: Bool = false

    // タイマー関連
    private var timer: Timer?
    private var startTime: Date?
    private let setDuration: TimeInterval = 3 // 1分=60秒

    // 検査データ
    private var correctAnswers: Int = 0
    private var totalAnswers: Int = 0
    private var setResults: [Double] = [] // 各セットの正答率

    // 検査の総セット数
    private let totalSets: Int = 3

    // コールバック
    var onSetComplete: (() -> Void)?

    // 初期化
    init() {
        generateNumbers()
    }

    // 検査開始
    func startTest() {
        resetTestData()
        isTestComplete = false
        startTimer()
    }
    // 次のセットへ移動
    func moveToNextSet() {
        // 現在のセットの結果を保存
        if totalAnswers > 0 {
            let accuracy = Double(correctAnswers) / Double(totalAnswers)
            setResults.append(accuracy)
        } else {
            setResults.append(0.0)
        }

        // 次のセットへ
        currentSetIndex += 1

        // 完了判定を明示的に行う
        if currentSetIndex >= totalSets {
            isTestComplete = true
            return // 完了の場合は以降の処理をスキップ
        }

        // データリセット
        correctAnswers = 0
        totalAnswers = 0
        currentIndex = 0
        lastInput = nil

        // 新しい数字列を生成
        generateNumbers()

        // タイマー再開
        startTimer()
    }

    // 答えの入力処理
    func inputAnswer(_ number: Int) {
        // 入力できるのは検査中のみ
        guard currentIndex < currentNumbers.count - 1 && timer != nil else { return }

        // 入力を記録
        lastInput = number

        // 正誤判定
        let correctAnswer = (currentNumbers[currentIndex] + currentNumbers[currentIndex + 1]) % 10
        if number == correctAnswer {
            correctAnswers += 1
        }

        // 総回答数カウント
        totalAnswers += 1

        // 次の問題へ
        currentIndex += 1

        // 最後まで到達したら新しい数字を生成
        if currentIndex >= currentNumbers.count - 1 {
            generateNumbers()
            currentIndex = 0
        }
    }

    // 検査結果の生成
    func generateTestResult() -> TestResult {
        // 最後のセットの結果も追加（途中で終了した場合）
        if currentSetIndex < totalSets && timer != nil {
            let accuracy = totalAnswers > 0 ? Double(correctAnswers) / Double(totalAnswers) : 0.0
            setResults.append(accuracy)
        }

        // タイマーを停止
        stopTimer()

        // 足りないセットを0.0で埋める
        while setResults.count < totalSets {
            setResults.append(0.0)
        }

        // 全体の正答率を計算
        let totalCorrect = setResults.enumerated().reduce(0.0) { (sum, item) in
            return sum + item.element
        }
        let totalAccuracy = setResults.isEmpty ? 0.0 : totalCorrect / Double(setResults.count)

        // 検査結果オブジェクトを作成
        return TestResult(
            id: UUID(),
            date: Date(),
            overallAccuracy: totalAccuracy,
            setAccuracies: setResults
        )
    }

    // ランダムな数字列の生成
    private func generateNumbers() {
        // 30個程度の一桁数字をランダムに生成
        currentNumbers = (0..<30).map { _ in Int.random(in: 0...9) }
    }

    // タイマーの開始
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

    // タイマーの停止
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // 検査データのリセット
    private func resetTestData() {
        currentSetIndex = 0
        correctAnswers = 0
        totalAnswers = 0
        currentIndex = 0
        lastInput = nil
        setResults = []
        generateNumbers()
    }

    // デストラクタでタイマーを確実に破棄
    deinit {
        stopTimer()
    }
}
