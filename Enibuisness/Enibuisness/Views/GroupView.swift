//
//  GroupView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

// MARK: - GroupView
struct GroupView: View {
    @ObservedObject var groupViewModel: GroupVM

    var body: some View {
        VStack{
            Text("Group Screen")
                .font(.title)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    GroupView(groupViewModel: GroupVM())
}
