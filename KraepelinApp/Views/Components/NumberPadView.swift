//
//  NumberPadView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//


import SwiftUI

struct NumberPadView: View {
    let onNumberTapped: (Int) -> Void

    // キーパッドのレイアウト
    private let keyLayout = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
        [0]
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(keyLayout, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { number in
                        Button(action: {
                            onNumberTapped(number)
                        }) {
                            Text("\(number)")
                                .font(.system(.title, design: .monospaced))
                                .fontWeight(.medium)
                                .frame(minWidth: number == 0 ? 220 : 70, minHeight: 70)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct NumberPadView_Previews: PreviewProvider {
    static var previews: some View {
        NumberPadView(onNumberTapped: { _ in })
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
