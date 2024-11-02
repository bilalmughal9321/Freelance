//
//  ChatView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var chatViewModel: ChatVM

    var body: some View {
        VStack{
            Text("Chat Screen")
                .font(.title)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
            
    }
}

#Preview {
    ChatView(chatViewModel: ChatVM())
}
