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
    
    @State private var isShowing = false
    
    @State private var isContactScreen = false 
    
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
                    
                    Button {
                        isContactScreen = true
                    } label: {
                        Text("+ Invite someone to the group")
                            .font(.title3)
                            .padding(.leading, 10)
                                .foregroundStyle(.blue)
                                .bold()
                    }
                    
                        
                    
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
                        }.onLongPressGesture {
                            isShowing = true
                        }
                        .contextMenu(isShowing ? ContextMenu(menuItems: {
                            Button(action: {
                                print("Send message")
                            }) {
                                Label("Send message", systemImage: "")
                                   
                            }
                            
                            Button(action: {
                                print("Send referral")
                            }) {
                                Label("Send referral", systemImage: "")
                                    .background(Color.red)
                            }
                            
                            Button(action: {
                                print("Request 1 to 1")
                            }) {
                                Label("Request 1 to 1", systemImage: "")
                                    .background(Color.red)
                            }
                        }
                                    ) : nil)
                                     
                        .onDisappear {
                            isShowing = false // Reset when menu disappears
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
        .sheet(isPresented: $isContactScreen) {
            ContactsView()
            
        }
    }
}

#Preview {
    GroupView(groupViewModel: GroupVM())
}


//struct ContactsView: View {
//    @StateObject private var viewModel = ContactsVM()
//
//    var body: some View {
//        NavigationView {
//            Group {
//                if viewModel.permissionDenied {
//                    Text("Permission to access contacts was denied.")
//                        .foregroundColor(.red)
//                        .padding()
//                } else {
//                    List(viewModel.contacts, id: \.identifier) { contact in
//                        VStack(alignment: .leading) {
//                            Text("\(contact.givenName) \(contact.familyName)")
//                                .font(.headline)
//                            if let phone = contact.phoneNumbers.first?.value.stringValue {
//                                Text(phone)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Contacts")
//            .onAppear {
//                viewModel.requestAccess()
//            }
//        }
//    }
//}
