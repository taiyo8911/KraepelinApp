//
//  DetailView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
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
                detailDataSection
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
            Text("セット別の結果")
                .font(.headline)
                .padding(.bottom, 8)
                .dynamicTypeSize(...standardDynamicTypeLimit)

            // グラフ表示（iOS 16以上／未満で分岐）
            chartView
                .padding(.bottom, 16)
        }
    }

    // 詳細データセクション
    private var detailDataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("詳細データ")
                .font(.headline)
                .dynamicTypeSize(...standardDynamicTypeLimit)

            detailList
        }
    }

    // MARK: - グラフビュー
    // iOS バージョンに応じたグラフの表示
    private var chartView: some View {
        Group {
            if #available(iOS 16.0, *) {
                modernChartView
                    .frame(height: 250)
            } else {
                OldIOSChartView(
                    setAccuracies: testResult.setAccuracies,
                    correctCounts: testResult.correctCounts,
                    totalCounts: testResult.totalCounts
                )
            }
        }
    }

    // iOS 16以上用のモダンなChart
    @available(iOS 16.0, *)
    private var modernChartView: some View {
        Chart {
            ForEach(0..<testResult.setAccuracies.count, id: \.self) { index in
                // 正解数の棒グラフ
                BarMark(
                    x: .value("セット", "\(index + 1)"),
                    y: .value("正解数", testResult.correctCounts[index])
                )
                .foregroundStyle(Color.blue.opacity(0.7))

                // 正答率の折れ線グラフ
                LineMark(
                    x: .value("セット", "\(index + 1)"),
                    y: .value("正答率", testResult.setAccuracies[index] * 100)
                )
                .foregroundStyle(Color.red)
                .lineStyle(StrokeStyle(lineWidth: 2))
                .symbol {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisValueLabel().foregroundStyle(Color.blue)
            }

            AxisMarks(position: .trailing) { value in
                AxisValueLabel {
                    Text("\(value.as(Int.self) ?? 0)%")
                        .foregroundStyle(Color.red)
                }
            }
        }
        .chartLegend(position: .top)
        .dynamicTypeSize(...standardDynamicTypeLimit)
    }

    // MARK: - 詳細データリスト
    // 詳細データリスト（表形式）
    private var detailList: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 表のヘッダー
            detailHeader
                .background(Color.gray.opacity(0.1))
                .cornerRadius(4)

            // 表の行
            ForEach(0..<testResult.setAccuracies.count, id: \.self) { index in
                detailRow(index: index)
                    .background(index % 2 == 0 ? Color.white : Color.gray.opacity(0.05))
                    .cornerRadius(4)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .padding(.vertical, 4)
    }

    // 詳細データのヘッダー
    private var detailHeader: some View {
        HStack {
            Text("セット")
                .font(.headline)
                .frame(width: 60, alignment: .leading)
                .padding(.horizontal, 8)

            Spacer()

            Text("正解数")
                .font(.headline)
                .frame(width: 100, alignment: .center)
                .padding(.horizontal, 8)

            Spacer()

            Text("正答率")
                .font(.headline)
                .frame(width: 80, alignment: .trailing)
                .padding(.horizontal, 8)
        }
        .padding(.vertical, 10)
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
    }

    // 詳細データの1行
    private func detailRow(index: Int) -> some View {
        let accuracy = testResult.setAccuracies[index]
        return HStack {
            Text("\(index + 1)")
                .font(.subheadline)
                .frame(width: 60, alignment: .leading)
                .padding(.horizontal, 8)

            Spacer()

            Text("\(testResult.correctCounts[index])/\(testResult.totalCounts[index])")
                .font(.body)
                .foregroundColor(.blue)
                .frame(width: 100, alignment: .center)
                .padding(.horizontal, 8)

            Spacer()

            Text("\(Int(accuracy * 100))%")
                .font(.body)
                .foregroundColor(accuracyColor(accuracy))
                .frame(width: 80, alignment: .trailing)
                .padding(.horizontal, 8)
        }
        .padding(.vertical, 10)
        .dynamicTypeSize(...detailRowDynamicTypeLimit)
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
