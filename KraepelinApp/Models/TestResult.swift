//
//  TestResult.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import Foundation

struct TestResult: Identifiable, Codable {
    let id: UUID
    let date: Date
    let overallAccuracy: Double // 全体の正答率
    let setAccuracies: [Double] // 各セットの正答率

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

    init(id: UUID = UUID(), date: Date = Date(), overallAccuracy: Double, setAccuracies: [Double]) {
        self.id = id
        self.date = date
        self.overallAccuracy = overallAccuracy
        self.setAccuracies = setAccuracies
    }
}
