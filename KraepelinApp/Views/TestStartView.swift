//
//  TestStartView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct TestStartView: View {
    @EnvironmentObject var appStateManager: AppStateManager

    var body: some View {
        VStack(spacing: 30) {
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

            Spacer()

            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.orange)

            Text("検査を開始します")
                .font(.title)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 15) {
                NoticeRow(
                    icon: "clock.fill",
                    title: "検査時間",
                    description: "1分×15セットの合計15分間です"
                )

                NoticeRow(
                    icon: "iphone.and.arrow.forward",
                    title: "中断禁止",
                    description: "検査中は他のアプリを使用したり、画面を閉じたりしないでください"
                )

                NoticeRow(
                    icon: "bell.slash.fill",
                    title: "通知をオフに",
                    description: "検査中は電話やメッセージなどの通知をオフにすることをお勧めします"
                )

                NoticeRow(
                    icon: "brain.head.profile",
                    title: "集中環境",
                    description: "静かな環境で集中して取り組んでください"
                )
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()

            Button(action: {
                appStateManager.activeScreen = .countdown
            }) {
                Text("検査を開始する")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

struct NoticeRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct TestStartView_Previews: PreviewProvider {
    static var previews: some View {
        TestStartView()
            .environmentObject(AppStateManager.shared)
    }
}
