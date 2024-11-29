//
//  ContactsViewModel.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 28/11/2024.
//

import SwiftUI
import Contacts

class ContactsVM: ObservableObject {
    @Published var contacts: [CNContact] = []
    @Published var permissionDenied = false

    func requestAccess() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.fetchContacts()
                } else {
                    self.permissionDenied = true
                }
            }
        }
    }

    func fetchContacts() {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)

        var fetchedContacts: [CNContact] = []
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                fetchedContacts.append(contact)
            }
            DispatchQueue.main.async {
                self.contacts = fetchedContacts
            }
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
}
