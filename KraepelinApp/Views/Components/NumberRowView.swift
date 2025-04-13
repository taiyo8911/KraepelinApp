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

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<numbers.count, id: \.self) { index in
                        Text("\(numbers[index])")
                            .font(.title)
                            .fontWeight(.medium)
                            .frame(width: 40, height: 40)
                            .background(
                                index == currentIndex ?
                                    Color.blue.opacity(0.3) :
                                    (index < currentIndex ?
                                        Color.gray.opacity(0.1) :
                                        Color.clear)
                            )
                            .cornerRadius(8)
                            .id(index)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct NumberRowView_Previews: PreviewProvider {
    static var previews: some View {
        NumberRowView(
            numbers: [3, 8, 2, 5, 9, 1, 4, 7, 6, 2, 3],
            currentIndex: 3
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
