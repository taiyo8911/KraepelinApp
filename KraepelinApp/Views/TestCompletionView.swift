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

    // 結果を生成して保持
    @State private var testResult: TestResult

    init() {
        // 初期化時は空のTestResultを作成
        _testResult = State(initialValue: TestResult(
            overallAccuracy: 0,
            setAccuracies: [],
            correctCounts: [],
            totalCounts: []
        ))
    }

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

            NavigationLink(destination: DetailView(testResult: testResult)) {
                Text("結果を見る")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            // onAppearで結果を生成
            testResult = viewModel.generateTestResult()
            // 結果を保存
            UserDefaultsManager.shared.addTestResult(testResult)
        }
    }
}

struct TestCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        TestCompletionView()
            .environmentObject(TestViewModel())
    }
}

