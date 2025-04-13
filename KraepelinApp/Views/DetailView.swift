//
//  DetailView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//


import SwiftUI
import Charts

struct DetailView: View {
    let testResult: TestResult

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 検査日時
                HStack {
                    Text("検査日時:")
                        .font(.headline)
                    Text(testResult.formattedDate)
                        .font(.subheadline)
                }
                .padding(.bottom, 8)

                // 総合正答率
                HStack {
                    Text("総合正答率:")
                        .font(.headline)
                    Text("\(Int(testResult.overallAccuracy * 100))%")
                        .font(.title)
                        .foregroundColor(accuracyColor(testResult.overallAccuracy))
                }
                .padding(.bottom, 16)

                // セットごとの正答率グラフ
                Text("セットごとの正答率")
                    .font(.headline)
                    .padding(.bottom, 8)

                if #available(iOS 16.0, *) {
                    Chart {
                        ForEach(Array(testResult.setAccuracies.enumerated()), id: \.offset) { index, accuracy in
                            BarMark(
                                x: .value("セット", "セット\(index + 1)"),
                                y: .value("正答率", accuracy * 100)
                            )
                            .foregroundStyle(accuracyColor(accuracy))
                        }
                    }
                    .frame(height: 250)
                    .padding(.bottom, 16)
                } else {
                    // iOS 16未満の場合はグラフの代わりにリスト表示
                    accuracyBars
                }

                // セットごとの詳細リスト
                Text("詳細データ")
                    .font(.headline)
                    .padding(.bottom, 8)

                ForEach(Array(testResult.setAccuracies.enumerated()), id: \.offset) { index, accuracy in
                    HStack {
                        Text("セット\(index + 1)")
                            .font(.subheadline)
                        Spacer()
                        Text("\(Int(accuracy * 100))%")
                            .font(.body)
                            .foregroundColor(accuracyColor(accuracy))
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
        }
        .navigationTitle("検査結果詳細")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var accuracyBars: some View {
        VStack(spacing: 8) {
            ForEach(Array(testResult.setAccuracies.enumerated()), id: \.offset) { index, accuracy in
                HStack {
                    Text("セット\(index + 1)")
                        .font(.caption)
                        .frame(width: 60, alignment: .leading)

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: geometry.size.width, height: 20)
                                .opacity(0.1)
                                .foregroundColor(.gray)

                            Rectangle()
                                .frame(width: geometry.size.width * CGFloat(accuracy), height: 20)
                                .foregroundColor(accuracyColor(accuracy))
                        }
                        .cornerRadius(4)
                    }
                    .frame(height: 20)

                    Text("\(Int(accuracy * 100))%")
                        .frame(width: 40, alignment: .trailing)
                        .font(.caption)
                }
            }
        }
        .frame(height: 400)
    }

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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(testResult: TestResult(
                id: UUID(),
                date: Date(),
                overallAccuracy: 0.78,
                setAccuracies: [0.9, 0.85, 0.75, 0.8, 0.82, 0.79, 0.77, 0.73, 0.75, 0.78, 0.76, 0.72, 0.7, 0.65, 0.68]
            ))
        }
    }
}
