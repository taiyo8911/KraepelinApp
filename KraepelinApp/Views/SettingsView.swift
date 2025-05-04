//
//  SettingsView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/28.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - プロパティ
    @EnvironmentObject var appStateManager: AppStateManager
    @State private var selectedSetsCount: Double

    // 定数
    private let minSetsCount: Double = 1 // 設定できるセット数の最小値
    private let maxSetsCount: Double = 15 // 設定できるセット数の最大値
    private let containerWidth: CGFloat = UIScreen.main.bounds.width * 0.8

    // MARK: - 初期化
    init() {
        let savedCount = UserDefaultsManager.shared.getTestSetsCount()
        _selectedSetsCount = State(initialValue: Double(savedCount))
    }

    // MARK: - ビュー
    var body: some View {
        VStack(spacing: 30) {
            navigationBar
            settingsSection
            descriptionSection
            Spacer()
        }
        .padding()
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }

    // MARK: - コンポーネント
    // ナビゲーションバー
    private var navigationBar: some View {
        VStack {

        }
        // ナビゲーションバーのタイトル
        .navigationTitle("設定")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    appStateManager.activeScreen = .home
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("戻る")
                    }
                }
            }
        }

    }

    // 設定セクション
    private var settingsSection: some View {
        VStack {
            Text("セット数の設定")
                .font(.title2)
                .fontWeight(.bold)

            counterControl

            saveButton
        }
        .frame(width: containerWidth)
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }

    // カウンター制御
    private var counterControl: some View {
        HStack {
            CounterButton(
                action: decrementCount,
                systemName: "minus.circle.fill",
                color: .red
            )

            Text("\(Int(selectedSetsCount))")
                .font(.title)

            CounterButton(
                action: incrementCount,
                systemName: "plus.circle.fill",
                color: .blue
            )
        }
    }

    // 保存ボタン
    private var saveButton: some View {
        Button(action: saveSettings) {
            Text("設定を保存")
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.green)
                .cornerRadius(8)
        }
        .padding(.top, 10)
    }

    // 説明セクション
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("セット数について")
                .font(.headline)

            Text("本来のクレペリン検査は、1分×15セット×2回で行われますが、このアプリでは練習用に少ないセット数に設定することができます。")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: containerWidth)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }

    // MARK: - アクション

    private func decrementCount() {
        if selectedSetsCount > minSetsCount {
            selectedSetsCount -= 1
        }
    }

    private func incrementCount() {
        if selectedSetsCount < maxSetsCount {
            selectedSetsCount += 1
        }
    }

    private func saveSettings() {
        UserDefaultsManager.shared.saveTestSetsCount(Int(selectedSetsCount))
        navigateToHome()
    }

    private func navigateToHome() {
        appStateManager.activeScreen = .home
    }
}

// MARK: - ヘルパービュー

struct CounterButton: View {
    let action: () -> Void
    let systemName: String
    let color: Color

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundColor(color)
                .font(.title)
        }
        .padding(20)
    }
}


// MARK: - プレビュー
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppStateManager.shared)
    }
}
