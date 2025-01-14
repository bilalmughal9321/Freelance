//
//  ContentView.swift
//  ChatApp
//
//  Created by Bilal Mughal on 14/01/2025.
//

import SwiftUI

struct Message: Identifiable, Equatable {
    var id = UUID()
    var text: String
    var isSender: Bool
}

struct ContentView: View {
    
    @State var messages: [Message] = []
    
    var data: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived"
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                VStack(spacing: 30) {
                    
                    ForEach(messages) { message in
                        if message.isSender {
                            SenderView(message: message)
                        }
                        else {
                            ReceiverView(message: message)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
               
                .onChange(of: messages, {
                    withAnimation {
                        scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                })
               
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                messages.append(Message(text: data, isSender: true))
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    messages.append(Message(text: data, isSender: false))
                })
            })
        }
        
    }
}


struct SenderView: View {
    
    let message: Message
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.fill")
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.blue))
            Text(message.text)
                .foregroundStyle(.white)
                .bold()
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(.blue)
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .transition(.move(edge: .leading))
        .animation(.spring, value: message.id)
    }
}

struct ReceiverView: View {
    
    let message: Message
    
    var body: some View {
        HStack(alignment: .top) {
            Text(message.text)
                .foregroundStyle(.white)
                .bold()
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray))
            Image(systemName: "person.fill")
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.gray))
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .transition(.move(edge: .trailing))
        .animation(.spring, value: message.id)
    }
}

#Preview {
    ContentView()
}
