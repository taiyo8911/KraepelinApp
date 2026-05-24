//
//  NumberPadView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//


import SwiftUI
import UIKit

struct NumberPadView: View {
    let onNumberTapped: (Int) -> Void

    // キーパッドのレイアウト（nil は空白のプレースホルダー）
    private let keyLayout: [[Int?]] = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
        [nil, 0, nil]
    ]

    private let keySize: CGFloat = 70

    // タップ時の触覚フィードバック
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        VStack(spacing: Spacing.m) {
            ForEach(keyLayout.indices, id: \.self) { rowIndex in
                HStack(spacing: Spacing.m) {
                    ForEach(keyLayout[rowIndex].indices, id: \.self) { colIndex in
                        if let number = keyLayout[rowIndex][colIndex] {
                            keyButton(for: number)
                        } else {
                            // 「0」の左右の空きスペース（同じサイズで配置を揃える）
                            Color.clear
                                .frame(width: keySize, height: keySize)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            // 初回タップの遅延を防ぐためにジェネレーターを準備
            hapticGenerator.prepare()
        }
    }

    private func keyButton(for number: Int) -> some View {
        Button {
            hapticGenerator.impactOccurred()
            onNumberTapped(number)
        } label: {
            Text("\(number)")
                .font(.system(.title, design: .monospaced))
                .fontWeight(.medium)
                .frame(width: keySize, height: keySize)
                .background(AppColor.primaryMuted)
                .foregroundColor(.primary)
                .cornerRadius(CornerRadius.m)
        }
    }
}

struct NumberPadView_Previews: PreviewProvider {
    static var previews: some View {
        NumberPadView(onNumberTapped: { _ in })
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
