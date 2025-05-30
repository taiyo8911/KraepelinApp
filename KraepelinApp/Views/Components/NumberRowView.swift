//
//  NumberRowView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct NumberRowView: View {
    // MARK: - プロパティ
    let numbersGrid: [[Int]]
    let answerHistoryGrid: [[Int?]]
    let currentRowIndex: Int  // 表示座標系での現在行（0-4）
    let currentColumnIndex: Int

    // 表示設定
    private let numberWidth: CGFloat = 32
    private let numberSpacing: CGFloat = 12
    private let rowSpacing: CGFloat = 0

    // 各行で表示する数字の範囲を制限（9文字表示）
    private let visibleNumbersPerRow: Int = 9

    // MARK: - メインビュー
    var body: some View {
        VStack(spacing: rowSpacing) {
            ForEach(0..<numbersGrid.count, id: \.self) { displayRowIndex in
                createRowView(for: displayRowIndex)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentRowIndex)
        .animation(.easeInOut(duration: 0.2), value: currentColumnIndex)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }

    // MARK: - コンポーネント

    /// 指定した行のビューを作成
    /// - Parameter displayRowIndex: 表示座標系での行インデックス（0-4）
    /// - Returns: その行のビュー
    private func createRowView(for displayRowIndex: Int) -> some View {
        guard displayRowIndex < numbersGrid.count else {
            return AnyView(EmptyView())
        }

        let numbers = numbersGrid[displayRowIndex]
        let answers = displayRowIndex < answerHistoryGrid.count ? answerHistoryGrid[displayRowIndex] : []
        let isCurrentRow = displayRowIndex == currentRowIndex

        return AnyView(
            VStack(spacing: 2) {
                // 数字行
                createNumbersRow(numbers: numbers,
                               isCurrentRow: isCurrentRow,
                               displayRowIndex: displayRowIndex)

                // 解答行
                createAnswersRow(answers: answers,
                               numbersCount: numbers.count,
                               isCurrentRow: isCurrentRow,
                               displayRowIndex: displayRowIndex)

                // マーカー行
                createMarkerRow(numbersCount: numbers.count,
                              isCurrentRow: isCurrentRow,
                              displayRowIndex: displayRowIndex)
            }
        )
    }

    /// 数字行を作成
    private func createNumbersRow(numbers: [Int], isCurrentRow: Bool, displayRowIndex: Int) -> some View {
        let visibleRange = getVisibleRange(for: numbers.count, isCurrentRow: isCurrentRow)

        return HStack(spacing: numberSpacing) {
            ForEach(Array(visibleRange), id: \.self) { columnIndex in
                Text("\(numbers[columnIndex])")
                    .font(.system(.title, design: .monospaced))
                    .foregroundColor(.green)
                    .frame(width: numberWidth, height: numberWidth)
            }
        }
        .padding(.horizontal)
    }

    /// 解答行を作成
    private func createAnswersRow(answers: [Int?], numbersCount: Int, isCurrentRow: Bool, displayRowIndex: Int) -> some View {
        let visibleRange = getVisibleRange(for: numbersCount, isCurrentRow: isCurrentRow)
        let answerRange = visibleRange.dropLast() // 最後の数字には解答スペースがない

        return HStack(spacing: numberSpacing) {
            ForEach(Array(answerRange), id: \.self) { columnIndex in
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: numberWidth, height: 24)

                    if columnIndex < answers.count, let answer = answers[columnIndex] {
                        Text("\(answer)")
                            .font(.system(.title2, design: .monospaced))
                            .foregroundColor(.black)
                    }
                }
                .offset(x: (numberWidth + numberSpacing) / 2)
            }

            // 最後の数字のためのスペース
            if !answerRange.isEmpty {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: numberWidth, height: 24)
            }
        }
        .padding(.horizontal)
    }

    /// マーカー行を作成
    private func createMarkerRow(numbersCount: Int, isCurrentRow: Bool, displayRowIndex: Int) -> some View {
        let visibleRange = getVisibleRange(for: numbersCount, isCurrentRow: isCurrentRow)
        let markerRange = visibleRange.dropLast() // 最後の数字にはマーカーがない

        return HStack(spacing: numberSpacing) {
            ForEach(Array(markerRange), id: \.self) { columnIndex in
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: numberWidth, height: 0)

                    if isCurrentRow && columnIndex == currentColumnIndex {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                    }
                }
                .offset(x: (numberWidth + numberSpacing) / 2)
            }

            // 最後の数字のためのスペース
            if !markerRange.isEmpty {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: numberWidth, height: 12)
            }
        }
    }

    // MARK: - ヘルパーメソッド

    /// 各行で表示する数字の範囲を取得
    /// - Parameters:
    ///   - count: その行の数字の総数
    ///   - isCurrentRow: 現在の行かどうか
    /// - Returns: 表示する範囲
    private func getVisibleRange(for count: Int, isCurrentRow: Bool) -> Range<Int> {
        // 現在の行の場合は、現在位置を中心に表示
        if isCurrentRow {
            let visibleCount = min(visibleNumbersPerRow, count)
            let centerIndex = currentColumnIndex
            let halfVisible = visibleCount / 2

            var startIndex = max(0, centerIndex - halfVisible)
            let endIndex = min(count, startIndex + visibleCount)

            // 終端に近い場合は調整
            if endIndex == count {
                startIndex = max(0, endIndex - visibleCount)
            }

            return startIndex..<endIndex
        } else {
            // 他の行の場合は先頭から表示
            let endIndex = min(visibleNumbersPerRow, count)
            return 0..<endIndex
        }
    }
}

// MARK: - プレビュー
struct NumberRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleNumbers = [
            [3, 8, 2, 5, 9, 1, 4, 7, 6, 2, 3, 8, 5],
            [5, 7, 3, 8, 1, 9, 2, 6, 4, 8, 5, 7, 2],
            [2, 9, 6, 4, 7, 3, 8, 1, 5, 2, 9, 6, 4],
            [8, 4, 1, 7, 2, 5, 9, 3, 6, 8, 4, 1, 7],
            [1, 6, 9, 2, 5, 8, 3, 7, 4, 1, 6, 9, 2]
        ]

        let sampleAnswers = [
            [1, 0, 7, 4, 0, 5, 1, 3, 8, 5, 1, 3, nil],
            [2, 0, 1, 9, 0, 1, 8, 0, 2, 3, 2, 9, nil],
            [1, 5, 0, 1, 0, 1, 9, 6, 7, 1, 5, 0, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
        ]

        NumberRowView(
            numbersGrid: sampleNumbers,
            answerHistoryGrid: sampleAnswers,
            currentRowIndex: 3,
            currentColumnIndex: 2
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
