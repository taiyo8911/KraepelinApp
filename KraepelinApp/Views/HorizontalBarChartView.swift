//
//  HorizontalBarChartView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/26.
//

import SwiftUI

struct HorizontalBarChartView: View {
    // MARK: - プロパティ
    let setAccuracies: [Double]
    let correctCounts: [Int]
    let totalCounts: [Int]

    // レイアウト定数
    private let setLabelWidth: CGFloat = 10
    private let accuracyLabelWidth: CGFloat = 50
    private let barHeight: CGFloat = 24
    private let spacing: CGFloat = 10

    // MARK: - メインビュー
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<correctCounts.count, id: \.self) { index in
                        createSetRow(for: index, totalWidth: geometry.size.width)
                    }
                }
                .padding()
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
    }

    // MARK: - コンポーネント
    /// 各セットの行を生成（セット名｜棒グラフ｜正答率）
    /// - Parameters:
    ///   - index: セットのインデックス
    ///   - totalWidth: 利用可能な全体幅
    /// - Returns: セット情報行のビュー
    private func createSetRow(for index: Int, totalWidth: CGFloat) -> some View {
        let accuracy = setAccuracies[index]
        let correctCount = correctCounts[index]

        // バーに使用可能な幅を計算
        let barWidth = totalWidth - setLabelWidth - accuracyLabelWidth - spacing * 3 - 16 // パディングを考慮

        return HStack(spacing: spacing) {
            // セット名
            Text("\(index + 1)")
                .font(.subheadline)
                .frame(width: setLabelWidth, alignment: .leading)

            // 棒グラフ
            ZStack(alignment: .leading) {
                // 背景バー
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: barHeight)
                    .cornerRadius(4)

                // 正解数バー
                if let maxCount = totalCounts.max(), maxCount > 0 {
                    Rectangle()
                        .fill(Color.blue.opacity(0.7))
                        .frame(width: CGFloat(correctCount) / CGFloat(maxCount) * barWidth, height: barHeight)
                        .cornerRadius(4)
                }
            }
            .frame(width: barWidth)

            // 正答率
            Text("\(Int(accuracy * 100))%")
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(width: accuracyLabelWidth, alignment: .trailing)
        }
        .frame(height: barHeight)
    }
}

// MARK: - プレビュー
struct HorizontalBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalBarChartView(
            setAccuracies: [0.9, 0.8, 0.7, 0.85, 0.92, 0.6, 0.75, 0.65, 0.88],
            correctCounts: [18, 16, 14, 17, 19, 12, 15, 13, 16],
            totalCounts: [20, 20, 20, 20, 20, 20, 20, 20, 20]
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .frame(height: 300)
    }
}
