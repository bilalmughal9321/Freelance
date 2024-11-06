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
    @State private var messages: [Message] = [
        Message(text: "Hi there!", isSender: true, time: "10:30 AM"),
        Message(text: "Hello! How are you?", isSender: false, time: "10:31 AM"),
        Message(text: "I am good, thanks! I am good, thanks! I am good, thanks! I am good, thanks!", isSender: true, time: "10:32 AM")
    ]
    @State private var newMessageText = ""
    
    var body: some View {
        VStack {
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
            
            // Bottom input area
            HStack {
                TextField("Message", text: $newMessageText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 8)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/))
                    
                
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
            .padding(isSender ? .leading : .trailing, 50) // Adjusts bubble padding
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

