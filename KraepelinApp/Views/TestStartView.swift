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
        VStack(spacing: Spacing.xxl) {
            HStack {
                Button {
                    appStateManager.activeScreen = .home
                } label: {
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
                .foregroundColor(AppColor.alert)

            Text("検査を開始します")
                .font(.title)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: Spacing.l) {
                NoticeRow(
                    icon: "iphone.and.arrow.forward",
                    title: "中断禁止",
                    description: "検査中は画面を閉じたりしないでください"
                )

                NoticeRow(
                    icon: "bell.slash.fill",
                    title: "通知をオフに",
                    description: "検査中は通知をオフにすることをお勧めします"
                )

                NoticeRow(
                    icon: "brain.head.profile",
                    title: "集中環境",
                    description: "静かな環境で集中して取り組んでください"
                )
            }
            .padding()
            .background(AppColor.primaryMuted)
            .cornerRadius(CornerRadius.m)
            .padding(.horizontal)
            .dynamicTypeSize(...DynamicTypeSize.xxLarge)

            Button {
                appStateManager.activeScreen = .countdown
            } label: {
                Text("検査を開始する")
            }
            .buttonStyle(.primary)
            .padding(.horizontal)
            .padding(.bottom)

            Spacer()
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

struct NoticeRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.l) {
            Image(systemName: icon)
                .foregroundColor(AppColor.primary)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
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
