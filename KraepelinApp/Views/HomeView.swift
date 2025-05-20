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
        VStack(spacing: 30) {
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

            VStack(spacing: 20) {
                Button(action: {
                    appStateManager.activeScreen = .testStart
                }) {
                    HStack {
                        Image(systemName: "play.fill")

                        Text("検査を始める")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                }

                Button(action: {
                    appStateManager.activeScreen = .tutorial
                }) {
                    HStack {
                        Image(systemName: "info.circle")

                        Text("説明を見る")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.green)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }

                Button(action: {
                    appStateManager.activeScreen = .history
                }) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("履歴を見る")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.green)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }

                Button(action: {
                    appStateManager.activeScreen = .settings
                }) {
                    HStack {
                        Image(systemName: "gear")
                        Text("設定")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.green)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            Spacer()

        }
        .padding()
        .foregroundColor(.green)
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
