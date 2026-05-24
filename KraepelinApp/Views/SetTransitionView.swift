//
//  SetTransitionView.swift
//  KraepelinApp
//
//  Created by Taiyo KOSHIBA on 2025/04/13.
//

import SwiftUI

struct SetTransitionView: View {
    var body: some View {
        ZStack {
            AppColor.background.opacity(0.9)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("次")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(AppColor.primary)
            }
        }
    }
}

struct SetTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        SetTransitionView()
    }
}
