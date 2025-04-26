//
//  DetailView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//
//


import SwiftUI
import Charts

struct DetailView: View {
    // MARK: - プロパティ
    @Environment(\.dismiss) var dismiss
    let testResult: TestResult

    // 動的フォントサイズの制限値
    private let standardDynamicTypeLimit = DynamicTypeSize.accessibility2
    private let detailRowDynamicTypeLimit = DynamicTypeSize.xxxLarge

    // MARK: - メインビュー
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                backButton
                testInfoSection
                chartSection
            }
            .padding()
        }
        .navigationTitle("検査結果詳細")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - セクションコンポーネント
    // 戻るボタン
    private var backButton: some View {
        Button(action: { dismiss() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("戻る")
            }
        }
        .padding(.bottom, 8)
        .dynamicTypeSize(...standardDynamicTypeLimit)
    }

    // 基本情報セクション
    private var testInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 検査日時
            HStack {
                Text("検査日時:")
                    .font(.headline)
                Text(testResult.formattedDate)
                    .font(.subheadline)
            }

            // 総合正答率
            HStack {
                Text("総合正答率:")
                    .font(.headline)
                Text("\(Int(testResult.overallAccuracy * 100))%")
                    .font(.title)
                    .foregroundColor(accuracyColor(testResult.overallAccuracy))
            }
            .padding(.bottom, 8)
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }


    // グラフセクション
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("セット別正解数")
                .font(.headline)
                .padding(.bottom, 8)
                .dynamicTypeSize(...standardDynamicTypeLimit)

            // 横棒グラフを表示
            HorizontalBarChartView(
                setAccuracies: testResult.setAccuracies,
                correctCounts: testResult.correctCounts,
                totalCounts: testResult.totalCounts
            )
            .padding(.bottom, 16)
        }
    }

    // MARK: - ヘルパーメソッド
    // 正答率によって色を決定
    private func accuracyColor(_ accuracy: Double) -> Color {
        switch accuracy {
        case 0.8...: return .green
        case 0.6..<0.8: return .yellow
        default: return .red
        }
    }
}

// MARK: - プレビュー
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(testResult: TestResult(
            id: UUID(),
            date: Date(),
            overallAccuracy: 0.78,
            setAccuracies: [0.9, 0.85, 0.75, 0.8, 0.82, 0.79],
            correctCounts: [18, 17, 15, 16, 16, 15],
            totalCounts: [20, 20, 20, 20, 20, 19]
        ))
    }
}
