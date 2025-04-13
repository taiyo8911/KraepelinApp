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
            description: "クレペリン検査は、一連の一桁の数字を足し算することで、持続的な注意力や作業能力を測定する検査です。",
            image: "number.circle"
        ),
        TutorialPage(
            title: "検査の方法",
            description: "隣り合う2つの数字を足して、その一の位の数字を入力していきます。例えば、3+8=11の場合は「1」と入力します。",
            image: "plus.circle"
        ),
        TutorialPage(
            title: "検査の流れ",
            description: "検査は1分間×15セットで行います。1分経過するごとに「次」と表示されて次のセットに進みます。",
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
                    VStack(spacing: 30) {
                        Image(systemName: tutorialPages[index].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.blue)

                        Text(tutorialPages[index].title)
                            .font(.title)
                            .fontWeight(.bold)

                        Text(tutorialPages[index].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
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
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
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
