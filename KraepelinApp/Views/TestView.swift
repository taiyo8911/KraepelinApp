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
    @State private var testResult: TestResult?

    var body: some View {
        ZStack {
            // メインの検査ビュー
            VStack {
                Spacer()

                // 5行の数字列の表示
                NumberRowView(
                    numbersGrid: viewModel.displayRows,
                    answerHistoryGrid: viewModel.displayAnswerHistory,
                    currentRowIndex: viewModel.displayCurrentRowIndex,
                    currentColumnIndex: viewModel.currentColumnIndex
                )

                // 数字キーパッド
                NumberPadView(onNumberTapped: { number in
                    viewModel.inputAnswer(number)
                })

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
                    AppColor.background.opacity(0.9)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Text("やめ")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(AppColor.primary)
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }

            // 完了画面のオーバーレイ
            if showCompletion, let result = testResult {
                ZStack {
                    AppColor.background.ignoresSafeArea()

                    VStack(spacing: Spacing.xxl) {
                        Text("検査完了")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("お疲れ様でした")
                            .font(.title2)

                        Text("すべてのセットが完了しました")
                            .font(.headline)
                            .padding(.bottom, Spacing.s)

                        Text("全体の正答率: \(Int(result.overallAccuracy * 100))%")
                            .font(.title3)
                            .padding()

                        Button {
                            viewModel.saveResult(result)
                            appStateManager.lastResultId = result.id
                            appStateManager.activeScreen = .detail
                        } label: {
                            Text("結果を見る")
                        }
                        .buttonStyle(.compactPrimary)
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
            Task { @MainActor in
                print("Set completed. Current set index: \(self.viewModel.currentSetIndex)")

                let isLastSet = self.viewModel.currentSetIndex == self.viewModel.totalSets - 1

                // 適切な遷移画面を表示
                withAnimation {
                    if isLastSet {
                        self.showFinalTransition = true
                    } else {
                        self.showSetTransition = true
                    }
                }

                // 1秒待ってから次の処理へ
                try? await Task.sleep(for: .seconds(1))

                // 遷移画面を閉じる
                withAnimation {
                    self.showSetTransition = false
                    self.showFinalTransition = false
                }

                if isLastSet {
                    print("Last set completed. Moving to completion screen.")

                    // 重要: 最後のセットの結果を保存
                    self.viewModel.saveCurrentSetResult()
                    self.viewModel.isTestComplete = true

                    // 結果オブジェクトは一度だけ生成する（body評価ごとに生成しない）
                    self.testResult = self.viewModel.generateTestResult()

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

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(AppStateManager.shared)
            .environmentObject(TestViewModel())
    }
}
