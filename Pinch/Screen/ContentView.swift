//
//  ContentView.swift
//  Pinch
//
//  Created by David Viloria Ortega on 21/09/24.
//

import SwiftUI

struct ContentView: View {
    
    //: MARK: - Properties
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding()
                    .shadow(color: .teal.opacity(0.6), radius: 12, x: 6, y: 2)
                    .opacity(isAnimating ? 1 : 0) // .animation(.linear(duration: 1), value: isAnimating)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                
                
                //: MARK - Tap Gesture
                    .onTapGesture(count: 2) {
                        if imageScale == 1{
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            withAnimation(.spring()) {
                                imageScale = 1
                            }
                        }
                    }
                
                //: MARK - Drag Gesture
                
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                withAnimation(.snappy(duration: 1)) {
                                    imageOffset = gesture.translation
                                }
                            })
                        
                            .onEnded({ _ in
                                withAnimation(.snappy) {
                                    imageOffset = .zero
                                }
                            })
                    )
                
            }//:ZSTACK
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            })
            .navigationTitle(Text("Pinch and Zoom"))
            .navigationViewStyle(.stack)
        }//: NAVIGATION
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
