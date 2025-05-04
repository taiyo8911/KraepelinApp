//
//  SettingsView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/28.
//


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appStateManager: AppStateManager

    // 内部状態としてセット数を保持
    @State private var selectedSetsCount: Double

    init() {
        // 初期値を UserDefaults から取得
        let savedCount = UserDefaultsManager.shared.getTestSetsCount()
        _selectedSetsCount = State(initialValue: Double(savedCount))
    }

    // 設定できるセット数の最小値
    private let minSetsCount: Double = 1

    // 設定できるセット数の最大値
    private let maxSetsCount: Double = 15


    var body: some View {
        VStack(spacing: 30) {
            // ヘッダー
            HStack {
                Button(action: {
                    appStateManager.activeScreen = .home
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("戻る")
                    }
                }
                .padding()

                Spacer()
            }


            // セット数設定
            VStack() {
                Text("セット数の設定")
                    .font(.title2)
                    .fontWeight(.bold)

                HStack {
                    // マイナスボタン
                    Button(action: {
                        // セット数を減らす
                        if selectedSetsCount > minSetsCount {
                            selectedSetsCount -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                    .padding(20)

                    Text("\(Int(selectedSetsCount))")
                        .font(.title)

                    // プラスボタン
                    Button(action: {
                        // セット数を増やす
                        if selectedSetsCount < maxSetsCount {
                            selectedSetsCount += 1
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .font(.title)
                    }
                    .padding(20)
                }

                Button(action: {
                    // セット数を保存
                    UserDefaultsManager.shared.saveTestSetsCount(Int(selectedSetsCount))

                    // 画面遷移
                    appStateManager.activeScreen = .home
                }) {
                    Text("設定を保存")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 10)
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)

//            Spacer()

            // 説明
            VStack(alignment: .leading, spacing: 10) {
                Text("セット数について")
                    .font(.headline)

                Text("本来のクレペリン検査は、1分×15セット×2回で行われますが、このアプリでは練習用に少ないセット数に設定することができます。")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Spacer()
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppStateManager.shared)
    }
}
