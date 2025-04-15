//
//  NumberRowView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct NumberRowView: View {
    let numbers: [Int]
    let currentIndex: Int

    // 表示する数字の範囲を制限
    private var visibleNumbersRange: Range<Int> {
        // 現在の位置から左右に表示する数字の数
        let visibleCount = 5

        let startIndex = max(0, currentIndex - visibleCount)
        let endIndex = min(numbers.count, currentIndex + visibleCount + 1)

        return startIndex..<endIndex
    }

    // ViewBuilderを使って数字とマーカーを別々に扱う方法
    var body: some View {
        VStack(spacing: 2) {
            // 数字の行 - 独立して配置
            numbersRow

            // マーカーの行 - 独立して配置
            markerRow
        }
        .animation(.easeInOut(duration: 0.2), value: currentIndex)
    }

    // 数字を表示する行
    private var numbersRow: some View {
        HStack(spacing: 16) {
            ForEach(Array(visibleNumbersRange), id: \.self) { index in
                Text("\(numbers[index])")
                    .font(.system(.title, design: .monospaced))
                    .fontWeight(.medium)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.primary) // すべての数字に同じ色を使用
            }
        }
        .padding(.horizontal)
    }

    // マーカーを表示する行
    private var markerRow: some View {
        HStack(spacing: 16) {
            ForEach(Array(visibleNumbersRange.dropLast()), id: \.self) { index in
                // 各数字の下にスペースを作成
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 40, height: 12)
                    .overlay(
                        // 現在のインデックスの位置にのみマーカーを表示
                        Group {
                            if index == currentIndex {
                                HStack(spacing: 0) {
                                    Spacer() // 左側のスペース

                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 8, height: 8)

                                    Spacer() // 右側のスペース
                                }
                                .frame(width: 56) // 数字の幅(40) + 間隔(16)
                                .offset(x: 28) // (数字の幅 + 間隔) / 2
                            }
                        }
                    )
            }

            // 最後の数字のためのスペース（マーカーがないため）
            if visibleNumbersRange.upperBound > visibleNumbersRange.lowerBound {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 40, height: 12)
            }
        }
        .padding(.horizontal)
    }
}

struct NumberRowView_Previews: PreviewProvider {
    static var previews: some View {
        NumberRowView(
            numbers: [3, 8, 2, 5, 9, 1, 4, 7, 6, 2, 3],
            currentIndex: 0
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
