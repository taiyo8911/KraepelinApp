//
//  TestCompletionView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct TestCompletionView: View {
    @EnvironmentObject var viewModel: TestViewModel
    @Environment(\.dismiss) var dismiss

    // アプリルートに戻るために使用
    @State private var backToRoot = false

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
            Text("全体の正答率: \(Int(viewModel.generateTestResult().overallAccuracy * 100))%")
                .font(.title3)
                .padding()

            Button("ホームに戻る") {
                // 結果を保存
                let result = viewModel.generateTestResult()
                UserDefaultsManager.shared.addTestResult(result)

                // 全ての画面を閉じる
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

