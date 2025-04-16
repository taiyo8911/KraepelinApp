//
//  DetailView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//


import SwiftUI
import Charts

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    let testResult: TestResult

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 戻るボタン
                backButton

                // 基本情報
                testInfo

                // グラフタイトル
                Text("セットごとの結果")
                    .font(.headline)
                    .padding(.bottom, 8)

                // グラフ表示（iOS 16以上／未満で分岐）
                if #available(iOS 16.0, *) {
                    modernChartView
                        .frame(height: 250)
                        .padding(.bottom, 16)
                } else {
                    // iOS 16未満用のカスタムチャート（別ファイルに分離）
                    OldIOSChartView(
                        setAccuracies: testResult.setAccuracies,
                        correctCounts: testResult.correctCounts,
                        totalCounts: testResult.totalCounts
                    )
                    .padding(.bottom, 16)
                }

                // 詳細データ
                detailList
            }
            .padding()
        }
        .navigationTitle("検査結果詳細")
        .navigationBarTitleDisplayMode(.inline)
    }

    // 戻るボタン
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("戻る")
            }
        }
        .padding(.bottom, 8)
    }

    // 基本情報
    private var testInfo: some View {
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
    }

    // iOS 16以上用のモダンなChart
    @available(iOS 16.0, *)
    private var modernChartView: some View {
        Chart {
            ForEach(0..<testResult.setAccuracies.count, id: \.self) { index in
                // 正解数の棒グラフ
                BarMark(
                    x: .value("セット", "セット\(index + 1)"),
                    y: .value("正解数", testResult.correctCounts[index])
                )
                .foregroundStyle(Color.blue.opacity(0.7))

                // 正答率の折れ線グラフ
                LineMark(
                    x: .value("セット", "セット\(index + 1)"),
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
    }

    // 詳細データリスト
    private var detailList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("詳細データ")
                .font(.headline)
                .padding(.bottom, 8)

            ForEach(0..<testResult.setAccuracies.count, id: \.self) { index in
                detailRow(index: index)
            }
        }
    }

    // 詳細データの1行
    private func detailRow(index: Int) -> some View {
        let accuracy = testResult.setAccuracies[index]
        return HStack {
            Text("セット\(index + 1)")
                .font(.subheadline)
            Spacer()
            Text("正解数: \(testResult.correctCounts[index])/\(testResult.totalCounts[index])")
                .font(.body)
                .foregroundColor(.blue)
            Spacer()
            Text("\(Int(accuracy * 100))%")
                .font(.body)
                .foregroundColor(accuracyColor(accuracy))
        }
        .padding(.vertical, 4)
    }

    // 色判定
    private func accuracyColor(_ accuracy: Double) -> Color {
        if accuracy >= 0.8 {
            return .green
        } else if accuracy >= 0.6 {
            return .yellow
        } else {
            return .red
        }
    }
}



// プレビュー
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
