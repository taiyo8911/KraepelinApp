//
//  DetailView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//


import SwiftUI
import Charts

struct DetailView: View {
    // MARK: - プロパティ
    // 以下のプロパティを追加
    @Environment(\.presentationMode) var presentationMode
    // ダイアログとして表示されている場合の識別フラグ
    var isModal: Bool = false

    @EnvironmentObject var appStateManager: AppStateManager

    @Environment(\.dismiss) var dismiss

    let testResult: TestResult

    // 動的フォントサイズの制限値
    private let maxDynamicTypeSize = DynamicTypeSize.accessibility2
    private let summaryDynamicTypeSize = DynamicTypeSize.accessibility1

    // MARK: - メインビュー
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 戻るボタンを条件付きで表示
                if isModal {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("戻る")
                        }
                    }
                    .padding(.bottom, 8)
                    .dynamicTypeSize(...maxDynamicTypeSize)
                }

                testSummarySection
                chartSection
            }
            .padding()

            VStack(alignment: .center) {
                homeButton
            }
        }
        .navigationTitle("検査結果詳細")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - コンポーネント
    // 戻るボタン
    private var backButton: some View {
        Button(action: { dismiss() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("戻る")
            }
        }
        .padding(.bottom, 8)
        .dynamicTypeSize(...maxDynamicTypeSize)
    }

    // 検査基本情報セクション
    private var testSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 検査日時
            HStack {
                Text("検査日時:")
                    .font(.headline)
                Text(testResult.formattedDate)
                    .font(.subheadline)
            }

            // 総合正答率
            HStack {
                Text("総合正答率:")
                    .font(.headline)
                Text("\(Int(testResult.overallAccuracy * 100))%")
                    .font(.title)
                    .foregroundColor(getAccuracyColor(testResult.overallAccuracy))
            }
        }
        .padding(.vertical, 8)
        .dynamicTypeSize(...summaryDynamicTypeSize)
    }

    // グラフセクション
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // セクションヘッダー
            Text("セット別結果")
                .font(.headline)
                .padding(.top, 8)
                .dynamicTypeSize(...maxDynamicTypeSize)

            // グラフタイトル
            HStack {
                Text("セット")
                    .font(.subheadline)
                    .frame(width: 50, alignment: .leading)

                Text("正答数")
                    .font(.subheadline)
                    .frame(width: 50, alignment: .leading)

                Spacer()

                Text("正答率")
                    .font(.subheadline)
                    .frame(width: 50, alignment: .leading)
            }

            // グラフ表示
            chartContent
        }
    }

    // グラフコンテンツ
    private var chartContent: some View {
        VStack(alignment: .leading) {
            // グラフの高さを適切に設定
            let graphHeight = CGFloat(testResult.setAccuracies.count) * 32 + 40

            // 棒グラフ
            HorizontalBarChartView(
                setAccuracies: testResult.setAccuracies,
                correctCounts: testResult.correctCounts,
                totalCounts: testResult.totalCounts
            )
            .frame(height: graphHeight)
            .padding(.bottom, 16)
        }
    }

    // ホームに戻るボタン
    private var homeButton: some View {
        VStack() {
            Button(action: {
                appStateManager.activeScreen = .home
            }) {
                Text("ホームに戻る")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
    }

    // MARK: - ヘルパーメソッド
    /// 正答率に基づいて色を返す
    /// - Parameter accuracy: 正答率 (0.0 ~ 1.0)
    /// - Returns: 対応する色
    private func getAccuracyColor(_ accuracy: Double) -> Color {
        switch accuracy {
        case 0.8...: return .green
        case 0.6..<0.8: return .yellow
        default: return .red
        }
    }
}

// MARK: - プレビュー
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(testResult: TestResult(
            id: UUID(),
            date: Date(),
            overallAccuracy: 0.78,
            setAccuracies: [0.9, 0.85, 0.75, 0.8, 0.82, 0.79, 0.88],
            correctCounts: [18, 17, 15, 16, 16, 15, 17],
            totalCounts: [20, 20, 20, 20, 20, 19, 20]
        ))
    }
}
