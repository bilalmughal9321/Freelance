//
//  ContactsView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 28/11/2024.
//

import Foundation
import SwiftUI

struct ContactsView: View {
    @StateObject private var viewModel = ContactsVM()
    @State private var isMessageComposePresented = false
    @State private var predefinedMessage = "Hello! This is a predefined message."
    @State private var selectedContacts = Set<String>() // Track selected contacts
    @State private var searchText = "" // For the search bar
    
    var body: some View {
        NavigationView {
            VStack {
                // Top Bar
                HStack {
                    Button("Close") {
                        // Close action
                    }
                    Spacer()
                    Text("Invite Friends")
                        .font(.headline)
                    Spacer()
                    Button("Select All") {
                        selectAllContacts()
                    }
                }
                .padding()
                
                // Search Bar
                HStack {
                    Spacer().frame(maxWidth: .infinity)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    Spacer().frame(maxWidth: .infinity)
                   
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                
                // Contacts List
                List(filteredContacts, id: \.identifier) { contact in
                    ZStack {
                        Color.black // Custom row background color
                        HStack {
                            // Placeholder for image or initials
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(String(contact.givenName.prefix(1)))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading) {
                                Text("\(contact.givenName) \(contact.familyName)")
                                    .font(.headline)
                                if let phone = contact.phoneNumbers.first?.value.stringValue {
                                    Text(phone)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            Button(action: {
                                toggleSelection(for: contact.identifier)
                            }) {
                                Image(systemName: selectedContacts.contains(contact.identifier) ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical)
                    }
                    .listRowInsets(EdgeInsets()) // Removes padding from the list row
                }
//                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .background(Color.black)
                
                
                
                // Bottom Button
                Button(action: {
                    isMessageComposePresented = true
                }) {
                    Text("Invite \(selectedContacts.count) Contact\(selectedContacts.count > 1 ? "s" : "")")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(selectedContacts.isEmpty) // Disable if no contact is selected
            }
            .background(.black)
            .onAppear {
                viewModel.requestAccess()
            }
            .sheet(isPresented: $isMessageComposePresented) {
                MessageComposeView(recipients: selectedContactNumbers, body: predefinedMessage) {
                    isMessageComposePresented = false
                }
            }
        }
       
    }
    
    // Filter contacts based on search text
    private var filteredContacts: [CNContact] {
        if searchText.isEmpty {
            return viewModel.contacts
        } else {
            return viewModel.contacts.filter { contact in
                contact.givenName.lowercased().contains(searchText.lowercased()) ||
                contact.familyName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private func toggleSelection(for contactID: String) {
        if selectedContacts.contains(contactID) {
            selectedContacts.remove(contactID)
        } else {
            selectedContacts.insert(contactID)
        }
    }
    
    private func selectAllContacts() {
        if selectedContacts.count == viewModel.contacts.count {
            selectedContacts.removeAll()
        } else {
            selectedContacts = Set(viewModel.contacts.map { $0.identifier })
        }
    }
    
    private var selectedContactNumbers: [String] {
        viewModel.contacts
            .filter { selectedContacts.contains($0.identifier) }
            .compactMap { $0.phoneNumbers.first?.value.stringValue }
    }
}




import MessageUI
import Contacts

struct MessageComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var body: String
    var onDismiss: () -> Void

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.recipients = recipients
        controller.body = body
        controller.messageComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(onDismiss: onDismiss)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let onDismiss: () -> Void

        init(onDismiss: @escaping () -> Void) {
            self.onDismiss = onDismiss
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: onDismiss)
        }
    }
}

struct Contact: Identifiable {
    var id: String { identifier } // Conform to Identifiable protocol
    let identifier: String
    let givenName: String
    let familyName: String
    let phoneNumbers: [CNLabeledValue<CNPhoneNumber>]
}


#Preview {
    ContactsView()
}

