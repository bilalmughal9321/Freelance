//
//  ContentView.swift
//  ChatApp
//
//  Created by Bilal Mughal on 14/01/2025.
//

import SwiftUI

struct Message: Identifiable, Equatable {
    var id = UUID()
    var text: String?
    var image: String?
    var isSender: Bool
}

struct ContentView: View {
    
    @State var time: Double = 1.0
    @State var messages: [Message] = []
    @State var isMediaSelected: Bool = false
    @State var selectedImages: [String] = []
    
    let imageNames = ["alert", "flower"]
    
    var data: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived"
    
    var body: some View {
        ZStack {
//            LinearGradient(colors: [.black,.clear, .purple],
//                           startPoint: gradientStartPoint(for: -time*2),
//                           endPoint: gradientEndPoint(for: -time)
//            )
//            .animation(.easeInOut(duration: 15), value: time)
//            .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    ScrollViewReader { scrollView in
                        VStack(spacing: 30) {
                            
                            ForEach(messages) { message in
                                
                                if message.isSender {
                                    
                                    if let imageName = message.image {
                                        Image(imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: 200, maxHeight: 150)
                                            .cornerRadius(10)
                                            .padding()
                                    }
                                    else if let text = message.text {
                                        SenderView(message: message)
                                    }
                                    
                                }
                                else {
                                    ReceiverView(message: message)
                                }
                            }
                            Spacer().id("Bottom")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .onChange(of: messages) {
                            withAnimation {
                                scrollView.scrollTo("Bottom", anchor: .bottom)
                            }
                        }
                        .onChange(of: isMediaSelected) {
                            if isMediaSelected {
                                withAnimation {
                                    scrollView.scrollTo("Bottom", anchor: .bottom)
                                }
                            }
                        }
                        
                    }
                }
                .onAppear {
                    messages.append(Message(text: data, isSender: true))
                    messages.append(Message(text: data, isSender: false))
//                    messages.append(Message(text: data, isSender: true))
//                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                        time += 20
//                    }
                }
                
//                MessageSection(isMedia: $isMediaSelected) { value in
//                    messages.append(Message(text: value, isSender: true))
//                }
                
                MessageSection(
                    isMedia: $isMediaSelected,
                    selectedImages: $selectedImages,
                    onMessage: { value in
                        messages.append(Message(text: value, isSender: true))
                    }, onImages: { images in
                        for imageName in selectedImages {
                            messages.append(Message(image: imageName, isSender: true))
                        }
                        selectedImages.removeAll()
                        isMediaSelected = false
                        
                    }
                )
                
                if isMediaSelected {
//                    Text("Media Selection View")
//                        .frame(maxWidth: .infinity, maxHeight: 230)
                    MediaGridView(images: imageNames, selectedImages: $selectedImages)
                                            .frame(maxWidth: .infinity, maxHeight: 230)
                }
            }
        }
    }
    
    // Calculate start point for the angle
       private func gradientStartPoint(for angle: Double) -> UnitPoint {
           let radians = angle * .pi / 180
           let x = cos(radians - .pi / 2) * 0.5 + 0.5
           let y = sin(radians - .pi / 2) * 0.5 + 0.5
           return UnitPoint(x: x, y: y)
       }
       
       // Calculate end point for the angle
       private func gradientEndPoint(for angle: Double) -> UnitPoint {
           let radians = angle * .pi / 180
           let x = cos(radians + .pi / 2) * 0.5 + 0.5
           let y = sin(radians + .pi / 2) * 0.5 + 0.5
           return UnitPoint(x: x, y: y)
       }
    
}

struct MediaGridView: View {
    let images: [String]
    @Binding var selectedImages: [String]
    
    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 10)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .padding(.horizontal)
                        .cornerRadius(8)
                        .onTapGesture {
                            if selectedImages.contains(imageName) {
                                selectedImages.removeAll { $0 == imageName }
                            } else {
                                selectedImages.append(imageName)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selectedImages.contains(imageName) ? Color.blue : Color.clear, lineWidth: 2)
                        )
                }
            }
            .padding()
        }
    }
}

struct MessageSection: View {
    @State private var value: String = ""
    @Binding var isMedia: Bool
    @Binding var selectedImages: [String]
    var onMessage: (String) -> Void
    var onImages: ([String]) -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isMedia.toggle()
                }
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 25))
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .background(Circle().fill(.gray.opacity(0.5)))
            }
            HStack {
                TextField("Type a message...", text: $value)
                    .background(Capsule().stroke(.clear, lineWidth: 1))
                    .frame(minHeight: 30)
                    .padding(.leading)
                
                Button(action: {
                    
                    if value != "" {
                        onMessage(value)
                    }
                    
                    if !selectedImages.isEmpty {
                        onImages(selectedImages)
                    }
                    
//                    guard value != "" else { return }
                    
                    
                    
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 35))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                }
            }
            .background(Capsule().stroke(.black.opacity(0.2),lineWidth: 1))
        }
        .padding()
    }
}

struct SenderView: View {
    
    let message: Message
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.fill")
                .foregroundStyle(.black)
                .frame(width: 30, height: 30)
                .background(
                    Circle().fill(
                        LinearGradient(
                            colors: [.white],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                )
            
            Text(message.text ?? "")
                .foregroundStyle(.white)
                .font(.footnote)
                .padding(10)
                .background(
                    RoundedRectangle(
                        cornerRadius: 10
                    )
                    .fill(
                        LinearGradient(
                            colors: [.blue],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.bouncy, value: message.id)
    }
}

struct ReceiverView: View {
    
    let message: Message
    
    var body: some View {
        HStack(alignment: .top) {
            Text(message.text ?? "")
                .foregroundStyle(.white)
//                .bold()
                .font(.footnote)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray))
            Image(systemName: "person.fill")
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.gray))
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
//        .transition(.move(edge: .trailing))
        .animation(.spring, value: message.id)
    }
}

#Preview {
    ContentView()
}


