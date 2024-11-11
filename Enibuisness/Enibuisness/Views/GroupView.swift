//
//  GroupView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

struct User: Identifiable {
    let id = UUID()
    let name: String
}


// MARK: - GroupView
struct GroupView: View {
    @ObservedObject var groupViewModel: GroupVM
    
    let users = [
        User(name: "User 1"),
        User(name: "User 2"),
        User(name: "User 3"),
        User(name: "User 4"),
        User(name: "User 5")
    ]
    
    var body: some View {
        
        VStack{
            Text("Group Screen")
                .font(.title)
                .foregroundStyle(.white)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("+ Invite someone to the group")
                        .font(.title3)
                        .padding(.leading, 10)
                        .foregroundStyle(.blue)
                        .bold()
                    
                    ForEach(users) { user in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            
                            Text(user.name)
                                .font(.headline)
                                .padding(.leading, 10)
                                .foregroundStyle(.white)
                            
                            
                            
                            Spacer()
                        }
//                        .padding()
//                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        Divider().background(Color.white)
                    }
                    
                }
                .padding()
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    GroupView(groupViewModel: GroupVM())
}
