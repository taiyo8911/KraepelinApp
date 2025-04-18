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
                .foregroundColor(.blue)

            Text("クレペリン検査")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            VStack(spacing: 20) {
                Button(action: {
                    appStateManager.activeScreen = .testStart
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                        Text("検査を始める")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }

                Button(action: {
                    appStateManager.activeScreen = .tutorial
                }) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                        Text("チュートリアル")
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }

                Button(action: {
                    appStateManager.activeScreen = .history
                }) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.blue)
                        Text("履歴を見る")
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            Spacer()

            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.secondary)

            Button(action: {
                // プライバシーポリシーへのリンク
                // UIApplication.shared.open(URL(string: "https://example.com/privacy")!)
            }) {
                Text("プライバシーポリシー")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .underline()
            }
            .padding(.bottom)
        }
        .padding()
    }
}

// プレビュー
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppStateManager.shared)
    }
}
