//
//  TestCompletionView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

// 結果表示用の独立したサブビューコンポーネント
struct ResultSummaryView: View {
    let accuracy: Double

    var body: some View {
        let percentage = Int(accuracy * 100)

        return Text("全体の正答率: \(percentage)%")
            .font(.title3)
            .fontWeight(.medium)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
    }
}

// ホームに戻るボタンコンポーネント
struct HomeButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("ホームに戻る")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 200)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

struct TestCompletionView: View {
    @EnvironmentObject var viewModel: TestViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 30) {
            Text("検査完了")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("お疲れ様でした")
                .font(.title2)

            Text("すべてのセットが完了しました")
                .font(.headline)
                .padding(.bottom, 10)

            // 単純な正答率表示
            Text("全体の正答率: 85%") // 実際の値を計算して表示する場合は修正
                .font(.title3)
                .padding()

            Button("ホームに戻る") {
                // ホーム画面への画面遷移
                dismiss()

            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 200)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
        .onAppear {
            print("TestCompletionView appeared")
        }
    }
}

// プレビュー用
struct TestCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        TestCompletionView()
            .environmentObject(TestViewModel())
    }
}
