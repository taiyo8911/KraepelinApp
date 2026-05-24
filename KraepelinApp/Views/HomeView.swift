//
//  HomeView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appStateManager: AppStateManager

    var body: some View {
        VStack(spacing: Spacing.xxl) {
            Spacer()

            Image(systemName: "brain.head.profile")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)

            Text("クレペリン検査練習")
                .font(.largeTitle)
                .fontWeight(.bold)
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

            Spacer()

            VStack(spacing: Spacing.l) {
                Button {
                    appStateManager.activeScreen = .testStart
                } label: {
                    Label("検査を始める", systemImage: "play.fill")
                }
                .buttonStyle(.primary)

                Button {
                    appStateManager.activeScreen = .tutorial
                } label: {
                    Label("説明を見る", systemImage: "info.circle")
                }
                .buttonStyle(.secondary)

                Button {
                    appStateManager.activeScreen = .history
                } label: {
                    Label("履歴を見る", systemImage: "clock.arrow.circlepath")
                }
                .buttonStyle(.secondary)

                Button {
                    appStateManager.activeScreen = .settings
                } label: {
                    Label("設定", systemImage: "gear")
                }
                .buttonStyle(.secondary)
            }
            .padding(.horizontal)

            Spacer()

        }
        .padding()
        .foregroundColor(AppColor.primary)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

// プレビュー
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppStateManager.shared)
    }
}
