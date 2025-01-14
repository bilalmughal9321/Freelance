//
//  ChatView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isSender: Bool
    let time: String
}

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var newMessageText = ""
    
    var body: some View {
        VStack {
            // Scrollable Chat Messages
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isSender {
                                Spacer() // Sender's message on right
                                MessageBubble(message: message, backgroundColor: Color.gray.opacity(0.7), isSender: message.isSender)
                            } else {
                                MessageBubble(message: message, backgroundColor: Color.blue, isSender: message.isSender)
                                Spacer() // Receiver's message on left
                            }
                        }
                    }
                }
                .padding()
            }
            
            // Centered Referral Form
            VStack {
                Text("Outside of the group")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                
                VStack(spacing: 25) {
                    TextField("Referral name", text: .constant(""))
                        .padding(.leading)
                        .padding(5)
                        .background(Capsule().stroke(Color.gray, lineWidth: 1))
                        .foregroundColor(.white)
                    
                    TextField("Referral phone number", text: .constant(""))
                        .padding(.leading)
                        .padding(5)
                        .background(Capsule().stroke(Color.gray, lineWidth: 1))
                        .foregroundColor(.white)
                    
                    TextField("Referral email", text: .constant(""))
                        .padding(.leading)
                        .padding(5)
                        .background(Capsule().stroke(Color.gray, lineWidth: 1))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        print("Referral sent!")
                    }) {
                        Text("Send referral")
                            .bold()
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .background(Capsule().fill(Color.blue))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                Text("Inside the group")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                    .bold()
                
                TextField("Search", text: .constant(""))
                    .padding(.leading)
                    .padding(5)
                    .background(Capsule().stroke(Color.gray, lineWidth: 1))
                    .foregroundColor(.gray)
                    .padding()
            }
            
//            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 20).stroke(.gray.opacity(0.2), lineWidth: 1)
            )
            .background(
                RoundedRectangle(cornerRadius: 20).fill(.gray.opacity(0.2))
            )
            .padding(40)
            .padding(.vertical)
//            .frame(maxWidth: 300)
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Color.gray, lineWidth: 1)
//                    .padding()
//            )
            
            // Bottom input area
            HStack {
                TextField("Message", text: $newMessageText)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))
                
                Button(action: sendMessage) {
                    Text("Send")
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
    
    // Method to add a new message
    private func sendMessage() {
        guard !newMessageText.isEmpty else { return }
        
        let newMessage = Message(
            text: newMessageText,
            isSender: true,
            time: DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        )
        messages.append(newMessage)
        newMessageText = ""
    }
}

// Message Bubble
struct MessageBubble: View {
    let message: Message
    let backgroundColor: Color
    let isSender: Bool
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            VStack(alignment: !isSender ? .trailing : .leading, spacing: 2) {
                Text(message.text)
                    .foregroundColor(.white)
                
                Text(message.time)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(16, corners: !isSender ? [.topRight, .bottomLeft, .bottomRight] : [.topLeft, .bottomLeft, .bottomRight])
            .padding(isSender ? .leading : .trailing, 50)
        }
    }
}

// Custom Shape and View extension for specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    ChatView()
}

