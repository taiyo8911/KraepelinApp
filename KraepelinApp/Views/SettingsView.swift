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

                Text("設定")
                    .font(.headline)
                    .padding()

                Spacer()
            }

            Spacer()

            // セット数設定
            VStack(alignment: .leading, spacing: 15) {
                Text("検査セット数")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("検査を行うセット数を設定します（3〜15セット）")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {
                    Text("3")

                    Slider(value: $selectedSetsCount, in: 3...15, step: 1)

                    Text("15")
                }

                Text("現在のセット数: \(Int(selectedSetsCount))")
                    .font(.headline)
                    .padding(.top, 10)

                Button(action: {
                    // セット数を保存
                    UserDefaultsManager.shared.saveTestSetsCount(Int(selectedSetsCount))

                    appStateManager.activeScreen = .home
                }) {
                    Text("設定を保存")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 10)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()

            // 説明
            VStack(alignment: .leading, spacing: 10) {
                Text("セット数について")
                    .font(.headline)

                Text("本来のクレペリン検査は15セット×2回で行われますが、練習用に少ないセット数に設定することができます。")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)

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
