////
////  TestResult.swift
////  KraepelinApp
////
////  Created by Taiyo KOSHIBA on 2025/04/13.
////
//
//import Foundation
//
//struct TestResult: Identifiable, Codable {
//    let id: UUID
//    let date: Date
//    let overallAccuracy: Double // 全体の正答率
//    let setAccuracies: [Double] // 各セットの正答率
//    let correctCounts: [Int] // 各セットの正解数
//    let totalCounts: [Int] // 各セットの問題数
//
//    var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        formatter.locale = Locale(identifier: "ja_JP")
//        return formatter.string(from: date)
//    }
//
//    init(id: UUID = UUID(), date: Date = Date(), overallAccuracy: Double, setAccuracies: [Double], correctCounts: [Int], totalCounts: [Int]) {
//        self.id = id
//        self.date = date
//        self.overallAccuracy = overallAccuracy
//        self.setAccuracies = setAccuracies
//        self.correctCounts = correctCounts
//        self.totalCounts = totalCounts
//    }
//}


//
//  TestResult.swift
//  KraepelinApp
//

//
//  TestResult.swift
//  KraepelinApp
//

//import Foundation
//
//// セットごとの結果を表す構造体
//struct SetData: Codable, Equatable {
//    let accuracy: Double // 正答率
//    let correctCount: Int // 正解数
//    let totalCount: Int // 問題数
//}
//
//// 検査結果を表す構造体
//struct TestResult: Identifiable, Codable {
//    let id: UUID // 一意のID
//    let date: Date // 検査日
//    let sets: [SetData] // セットごとの結果
//
//    // 全体の正答率（計算プロパティ）
//    var overallAccuracy: Double {
//        guard !sets.isEmpty else { return 0.0 } // セットが空でない場合のみ計算
//        return sets.reduce(0.0) { $0 + $1.accuracy } / Double(sets.count) // 全体の正答率を計算
//    }
//
//    // 日本語のフォーマットで日付を表示するプロパティ
//    var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        formatter.locale = Locale(identifier: "ja_JP")
//        return formatter.string(from: date)
//    }
//
//    // セットごとの正答率を取得するプロパティ
//    init(id: UUID = UUID(), date: Date = Date(), sets: [SetData]) {
//        self.id = id
//        self.date = date
//        self.sets = sets
//    }
//}


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
