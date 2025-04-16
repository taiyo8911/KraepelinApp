//
//  OldIOSChartView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/16.
//


import SwiftUI

struct OldIOSChartView: View {
    let setAccuracies: [Double]
    let correctCounts: [Int]
    let totalCounts: [Int]
    
    var body: some View {
        VStack(spacing: 12) {
            // 凡例
            legendView
            
            // バーグラフ
            barChartView
        }
    }
    
    // 凡例部分
    private var legendView: some View {
        HStack(spacing: 16) {
            legendItem(color: .blue.opacity(0.7), label: "正解数")
            legendItem(color: .red, label: "正答率")
        }
        .padding(.bottom, 8)
    }
    
    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(label)
                .font(.caption)
                .foregroundColor(color)
        }
    }
    
    // バーチャート部分
    private var barChartView: some View {
        let maxCount = totalCounts.max() ?? 1
        
        return VStack(spacing: 12) {
            ForEach(0..<setAccuracies.count, id: \.self) { index in
                barView(index: index, maxCount: maxCount)
            }
        }
    }
    
    // 単一のバー表示
    private func barView(index: Int, maxCount: Int) -> some View {
        let accuracy = setAccuracies[index]
        let correctCount = correctCounts[index]
        
        return VStack(alignment: .leading, spacing: 4) {
            Text("セット\(index + 1)")
                .font(.caption)
            
            // 正解数バー
            correctBar(correctCount: correctCount, maxCount: maxCount)
            
            // 正答率バー
            accuracyBar(accuracy: accuracy)
        }
    }
    
    // 正解数バー
    private func correctBar(correctCount: Int, maxCount: Int) -> some View {
        HStack(spacing: 0) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.gray.opacity(0.1))
                
                Rectangle()
                    .frame(width: barWidth(value: correctCount, max: maxCount), height: 20)
                    .foregroundColor(.blue.opacity(0.7))
            }
            .cornerRadius(4)
            
            Text("\(correctCount)")
                .font(.caption)
                .foregroundColor(.blue)
                .frame(width: 30)
        }
        .frame(height: 20)
    }
    
    // 正答率バー
    private func accuracyBar(accuracy: Double) -> some View {
        HStack(spacing: 0) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(.gray.opacity(0.1))
                
                Rectangle()
                    .frame(width: barWidth(value: accuracy, max: 1.0), height: 20)
                    .foregroundColor(accuracyColor(accuracy))
            }
            .cornerRadius(4)
            
            Text("\(Int(accuracy * 100))%")
                .font(.caption)
                .foregroundColor(.red)
                .frame(width: 30)
        }
        .frame(height: 20)
    }
    
    // バーの幅を計算（GeometryReaderなしでシンプルに）
    private func barWidth(value: Double, max: Double) -> CGFloat {
        return UIScreen.main.bounds.width * 0.7 * CGFloat(value) / CGFloat(max)
    }
    
    private func barWidth(value: Int, max: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 0.7 * CGFloat(value) / CGFloat(max)
    }
    
    // 色判定関数
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


struct OldIOSChartView_Previews: PreviewProvider {
    static var previews: some View {
        OldIOSChartView(
            setAccuracies: [0.9, 0.8, 0.7],
            correctCounts: [8, 7, 6],
            totalCounts: [10, 10, 10]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
