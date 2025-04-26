//
//  HorizontalBarChartView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/26.
//

import SwiftUI

struct HorizontalBarChartView: View {
    let setAccuracies: [Double]
    let correctCounts: [Int]
    let totalCounts: [Int]
    
    var body: some View {
        VStack(spacing: 16) {
            // 各セットの横棒グラフ
            ForEach(0..<correctCounts.count, id: \.self) { index in
                barRow(index: index)
            }
        }
        .padding()
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
    }
    
    // 各セットの行
    private func barRow(index: Int) -> some View {
        let accuracy = setAccuracies[index]
        let correctCount = correctCounts[index]
        _ = totalCounts[index]
        let maxCount = totalCounts.max() ?? 1
        
        return VStack(alignment: .leading, spacing: 4) {
            // セット番号と正答率
            HStack(alignment: .center) {
                Text("セット\(index + 1)")
                    .font(.headline)
                    .frame(width: 80, alignment: .leading)

                Spacer()

                Text("正答率: \(Int(accuracy * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }

            // 横棒グラフと正解数
            HStack(spacing: 8) {
                // 横棒グラフ
                ZStack(alignment: .leading) {
                    // 背景のバー
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 24)
                        .cornerRadius(4)

                    // 正解数のバー
                    Rectangle()
                        .fill(Color.blue.opacity(0.7))
                        .frame(width: calculateBarWidth(count: correctCount, maxCount: maxCount), height: 24)
                        .cornerRadius(4)
                }
            }
        }
    }
    
    // バーの幅を計算
    private func calculateBarWidth(count: Int, maxCount: Int) -> CGFloat {
        let maxWidth: CGFloat = UIScreen.main.bounds.width * 0.65
        return (CGFloat(count) / CGFloat(maxCount)) * maxWidth
    }
}

struct HorizontalBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalBarChartView(
            setAccuracies: [0.9, 0.8, 0.7, 0.85, 0.92, 0.6],
            correctCounts: [18, 16, 14, 17, 19, 12],
            totalCounts: [20, 20, 20, 20, 20, 20]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
