//
//  TestResult.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import Foundation

struct TestResult: Identifiable, Codable {
    // MARK: - プロパティ
    let id: UUID
    let date: Date
    let overallAccuracy: Double // 全体の正答率
    let setAccuracies: [Double] // 各セットの正答率
    let correctCounts: [Int] // 各セットの正解数
    let totalCounts: [Int] // 各セットの問題数

    // MARK: - 計算プロパティ
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

    // MARK: - イニシャライザ
    init(id: UUID = UUID(), date: Date = Date(), overallAccuracy: Double, setAccuracies: [Double], correctCounts: [Int], totalCounts: [Int]) {
        self.id = id
        self.date = date
        self.overallAccuracy = overallAccuracy
        self.setAccuracies = setAccuracies
        self.correctCounts = correctCounts
        self.totalCounts = totalCounts
    }
}
