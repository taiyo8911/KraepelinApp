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
    private let maxSetsCount: Double = 30 // 設定できるセット数の最大値

    // MARK: - 初期化
    init() {
        let savedCount = UserDefaultsManager.shared.getTestSetsCount()
        _selectedSetsCount = State(initialValue: Double(savedCount))
    }

    // MARK: - ビュー
    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width * 0.8
            VStack(spacing: Spacing.xxl) {
                navigationBar
                settingsSection(width: containerWidth)
                descriptionSection(width: containerWidth)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
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
    private func settingsSection(width: CGFloat) -> some View {
        VStack {
            Text("セット数の設定")
                .font(.title2)
                .fontWeight(.bold)

            counterControl

            saveButton
        }
        .frame(width: width)
        .padding()
        .background(AppColor.primaryMuted)
        .cornerRadius(CornerRadius.m)
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
        }
        .buttonStyle(.compactPrimary)
        .padding(.top, Spacing.s)
    }

    // 説明セクション
    private func descriptionSection(width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("セット数について")
                .font(.headline)

            Text("本来のクレペリン検査は、5分の休憩をはさんだ、前半15分・後半15分で行われますが、このアプリではセット数を自由に設定できます。")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: width)
        .padding()
        .background(AppColor.surfaceMuted)
        .cornerRadius(CornerRadius.m)
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
        .padding(Spacing.l)
    }
}


// MARK: - プレビュー
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppStateManager.shared)
    }
}
