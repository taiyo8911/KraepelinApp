//
//  HistoryView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @ObservedObject private var userDefaultsManager = UserDefaultsManager.shared
    @State private var showingAlert = false
    @State private var selectedResult: TestResult?

    var body: some View {
        Group {
            if userDefaultsManager.testResults.isEmpty {
                emptyView
            } else {
                listView
            }
        }
        .navigationTitle("履歴")
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

            ToolbarItem(placement: .bottomBar) {
                if !userDefaultsManager.testResults.isEmpty {
                    Button(action: {
                        showingAlert = true
                    }) {
                        Text("履歴を全て削除")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("履歴を全て削除"),
                message: Text("本当に全ての履歴を削除しますか？この操作は元に戻せません。"),
                primaryButton: .destructive(Text("削除")) {
                    userDefaultsManager.clearAllTestResults()
                },
                secondaryButton: .cancel(Text("キャンセル"))
            )
        }
        .sheet(item: $selectedResult) { result in
            DetailView(testResult: result)
        }
    }

    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("検査履歴がありません")
                .font(.title2)

            Button(action: {
                appStateManager.activeScreen = .home
            }) {
                Text("ホームに戻る")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding()
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }

    private var listView: some View {
        List {
            // 履歴のリスト（逆順に並び替え）
            ForEach(userDefaultsManager.testResults.sorted(by: { $0.date > $1.date })) { result in
                Button(action: {
                    selectedResult = result
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(result.formattedDate)
                                .font(.headline)
                            Text("総合正答率: \(Int(result.overallAccuracy * 100))%")
                                .font(.subheadline)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete(perform: deleteItem)
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)

    }

    private func deleteItem(at offsets: IndexSet) {
        userDefaultsManager.deleteTestResults(at: offsets)
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(AppStateManager.shared)
    }
}
