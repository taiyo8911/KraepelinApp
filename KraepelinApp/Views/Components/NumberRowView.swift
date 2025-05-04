//
//  NumberRowView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct NumberRowView: View {
    // MARK: - プロパティ
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

    // 数字の表示設定
    private let numberWidth: CGFloat = 40
    private let numberSpacing: CGFloat = 16

    // MARK: - メインビュー
    var body: some View {
        VStack(spacing: 2) {
            // 数字を表示する行
            numbersRow

            // マーカーを表示する行
            markerRow
        }
        .animation(.easeInOut(duration: 0.2), value: currentIndex)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }

    // MARK: - コンポーネント

    // 数字を表示する行
    private var numbersRow: some View {
        HStack(spacing: numberSpacing) {
            ForEach(Array(visibleNumbersRange), id: \.self) { index in
                Text("\(numbers[index])")
                    .font(.system(.title, design: .monospaced))
                    .fontWeight(.medium)
                    .frame(width: numberWidth, height: numberWidth)
                    .foregroundColor(.green)
            }
        }
        .padding(.horizontal)
    }

    // マーカーを表示する行
    private var markerRow: some View {
        HStack(spacing: numberSpacing) {
            ForEach(Array(visibleNumbersRange.dropLast()), id: \.self) { index in
                // 各数字の下にスペースを作成
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: numberWidth, height: 12)
                    .overlay(
                        // 現在のインデックスの位置にのみマーカーを表示
                        Group {
                            if index == currentIndex {
                                HStack(spacing: 0) {
                                    Spacer()

                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 8, height: 8)

                                    Spacer()
                                }
                                .frame(width: numberWidth + numberSpacing)
                                .offset(x: (numberWidth + numberSpacing) / 2)
                            }
                        }
                    )
            }

            // 最後の数字のためのスペース（マーカーがないため）
            if visibleNumbersRange.upperBound > visibleNumbersRange.lowerBound {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: numberWidth, height: 12)
            }
        }
        .padding(.horizontal)
    }
}

struct NumberRowView_Previews: PreviewProvider {
    static var previews: some View {
        NumberRowView(
            numbers: [3, 8, 2, 5, 9, 1, 4, 7, 6, 2, 3],
            currentIndex: 2
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
