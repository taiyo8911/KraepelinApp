//
//  TestView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

//import SwiftUI
//
//struct TestView: View {
//    @StateObject private var viewModel = TestViewModel()
//    @State private var showSetTransition = false
//    @State private var showCompletion = false
//
//    var body: some View {
//        ZStack {
//            // メインの検査ビュー
//            VStack {
//                Spacer()
//
//                // 数字列の表示
//                NumberRowView(numbers: viewModel.currentNumbers, currentIndex: viewModel.currentIndex)
//                    .padding()
//
//                Text("隣り合う数字を足してください")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    .padding()
//
//                Spacer()
//
//                // 数字キーパッド
//                NumberPadView(onNumberTapped: { number in
//                    viewModel.inputAnswer(number)
//                })
//                .padding(.bottom)
//            }
//
//            // セット切り替え画面のオーバーレイ
//            if showSetTransition {
//                SetTransitionView()
//                    .transition(.opacity)
//                    .zIndex(1)
//            }
//
//            // 非表示のナビゲーションリンク
////            NavigationLink(destination: TestCompletionView().environmentObject(viewModel), isActive: $showCompletion) {
////                EmptyView()
////            }
//
//        }
//        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            viewModel.startTest()
//
//            // タイマーの設定
//            viewModel.onSetComplete = {
//                print("Set completed. Current set index: \(self.viewModel.currentSetIndex)")
//
//                withAnimation {
//                    self.showSetTransition = true
//                }
//
//                // 1秒後に処理
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    if self.viewModel.currentSetIndex >= 3 { // totalSets=3の場合
//                        print("All sets completed. Moving to completion screen.")
//                        self.viewModel.isTestComplete = true
//                        self.showCompletion = true
//                    } else {
//                        withAnimation {
//                            self.showSetTransition = false
//                        }
//                        self.viewModel.moveToNextSet()
//                    }
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $showCompletion) {
//            NavigationStack {
//                TestCompletionView()
//                    .environmentObject(viewModel)
//            }
//        }
//    }
//}

import SwiftUI

struct TestView: View {
    @StateObject private var viewModel = TestViewModel()
    @State private var showSetTransition = false
    @State private var showCompletion = false

    var body: some View {
        ZStack {
            // メインの検査ビュー
            VStack {
                Spacer()

                // 数字列の表示
                NumberRowView(numbers: viewModel.currentNumbers, currentIndex: viewModel.currentIndex)
                    .padding()

                Text("隣り合う数字を足してください")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()

                Spacer()

                // 数字キーパッド
                NumberPadView(onNumberTapped: { number in
                    viewModel.inputAnswer(number)
                })
                .padding(.bottom)
            }

            // セット切り替え画面のオーバーレイ
            if showSetTransition {
                SetTransitionView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            setupViewModel()
        }
        // showCompletionの値が変わったときに確認するために追加
        .onChange(of: showCompletion) { newValue in
            print("showCompletion changed to: \(newValue)")
        }
        .fullScreenCover(isPresented: $showCompletion) {
            TestCompletionView()
                .environmentObject(viewModel)
        }
    }

    private func setupViewModel() {
        viewModel.startTest()

        viewModel.onSetComplete = {
            print("Set completed. Current set index: \(self.viewModel.currentSetIndex)")

            // UI更新は必ずメインスレッドで
            DispatchQueue.main.async {
                withAnimation {
                    self.showSetTransition = true
                }

                // 遅延処理
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // セット切り替え画面を閉じる
                    withAnimation {
                        self.showSetTransition = false
                    }

                    // 現在のセットが最後のセット（index=2）かどうかを確認
                    if self.viewModel.currentSetIndex == 2 {
                        print("Last set completed. Moving to completion screen.")

                        // 結果を作成し、isTestCompleteをtrueに設定
                        self.viewModel.isTestComplete = true

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
        NavigationStack {
            TestView()
        }
    }
}
