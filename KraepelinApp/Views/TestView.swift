//
//  TestView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @EnvironmentObject var viewModel: TestViewModel

    @State private var showSetTransition = false
    @State private var showFinalTransition = false
    @State private var showCompletion = false

    var body: some View {
        ZStack {
            // メインの検査ビュー
            VStack {
                Spacer()

                // 数字列の表示
                NumberRowView(numbers: viewModel.currentNumbers, currentIndex: viewModel.currentIndex)
                    .padding()

                Text("数字を入力してください")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                    .dynamicTypeSize(...DynamicTypeSize.accessibility2)

                Spacer()

                // 数字キーパッド
                NumberPadView(onNumberTapped: { number in
                    viewModel.inputAnswer(number)
                })
                .padding(.bottom)

                Spacer()
            }

            // セット切り替え画面のオーバーレイ
            if showSetTransition {
                SetTransitionView()
                    .transition(.opacity)
                    .zIndex(1)
            }

            // 最終セット完了画面のオーバーレイ
            if showFinalTransition {
                ZStack {
                    Color.white.opacity(0.9)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Text("終了")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }

            // 完了画面のオーバーレイ
            if showCompletion {
                ZStack {
                    Color.white.ignoresSafeArea()

                    VStack(spacing: 30) {
                        Text("検査完了")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("お疲れ様でした")
                            .font(.title2)

                        Text("すべてのセットが完了しました")
                            .font(.headline)
                            .padding(.bottom, 10)

                        // 正答率表示
                        let result = viewModel.generateTestResult()
                        Text("全体の正答率: \(Int(result.overallAccuracy * 100))%")
                            .font(.title3)
                            .padding()

                        Button("ホームに戻る") {
                            // 検査結果を保存
                            UserDefaultsManager.shared.addTestResult(result)

                            // ホーム画面に戻る
                            appStateManager.returnToHome()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding()
                }
                .zIndex(2)
            }
        }
        .onAppear {
            setupViewModel()
        }
    }

    private func setupViewModel() {
        viewModel.startTest()

        viewModel.onSetComplete = {
            print("Set completed. Current set index: \(self.viewModel.currentSetIndex)")

            // UI更新は必ずメインスレッドで
            DispatchQueue.main.async {
                // 現在のセットが最後のセットかどうかを確認（currentSetIndex == 2 for 3 sets）
                let isLastSet = self.viewModel.currentSetIndex == self.viewModel.totalSets - 1

                // 適切な遷移画面を表示
                withAnimation {
                    if isLastSet {
                        self.showFinalTransition = true
                    } else {
                        self.showSetTransition = true
                    }
                }

                // 遅延処理
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // 遷移画面を閉じる
                    withAnimation {
                        self.showSetTransition = false
                        self.showFinalTransition = false
                    }

                    if isLastSet {
                        print("Last set completed. Moving to completion screen.")

                        // 重要: 最後のセットの結果を保存
                        self.viewModel.saveCurrentSetResult()

                        // 結果を作成し、isTestCompleteをtrueに設定
                        self.viewModel.isTestComplete = true

                        // 完了画面を表示
                        self.showCompletion = true
                    } else {
                        // 次のセットへ
                        self.viewModel.moveToNextSet()
                    }
                }
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(AppStateManager.shared)
            .environmentObject(TestViewModel())
    }
}
