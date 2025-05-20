//
//  TutorialView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct TutorialView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @State private var currentPage = 0

    private let tutorialPages = [
        TutorialPage(
            title: "クレペリン検査とは",
            description: "一連の1桁の数字の足し算をするテストで、作業量の変化や傾向から性格や適性を診断する検査です。",
            image: "number.circle"
        ),
        TutorialPage(
            title: "検査の方法",
            description: "隣り合う2つの数字を足して、その一の位の数字を入力していきます。例えば、3+8=11の場合は「1」と入力します。",
            image: "plus.circle"
        ),
        TutorialPage(
            title: "検査時間",
            description: "通常の検査は、1分×15セットを2回（間に5分の休憩）行います。このアプリでは、設定画面からセット数を自由に変更できます。",
            image: "timer"
        ),
        TutorialPage(
            title: "集中して取り組む",
            description: "検査中は周囲の雑音がない環境で集中して取り組んでください。途中で中断せずに最後まで行うことが重要です。",
            image: "brain.head.profile"
        )
    ]

    var body: some View {
        VStack {
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

            TabView(selection: $currentPage) {
                ForEach(0..<tutorialPages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        Spacer()

                        Image(systemName: tutorialPages[index].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.green)

                        Text(tutorialPages[index].title)
                            .font(.title)
                            .fontWeight(.bold)

                        Text(tutorialPages[index].description)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)

                        Spacer()
                    }
                    .padding()
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            Button(action: {
                if currentPage < tutorialPages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    appStateManager.activeScreen = .home
                }
            }) {
                Text(currentPage < tutorialPages.count - 1 ? "次へ" : "理解しました")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

struct TutorialPage {
    let title: String
    let description: String
    let image: String
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
            .environmentObject(AppStateManager.shared)
    }
}
