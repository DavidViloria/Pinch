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
                Color.clear
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
                            resetImageState()
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
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                                
                            })
                    )
                
            }//:ZSTACK
            
            //: MARK: - INFO PANEL
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            })
            .navigationTitle(Text("Pinch and Zoom"))
            .navigationViewStyle(.stack)
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 20)
            }
            //: MARK: - CONTROLS
            .overlay (
                Group{
                    HStack{
                        //Scale Down
                        Button {
                            withAnimation(Animation.spring) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")

                        }
                        
                        // Reset
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")

                        }
                        
                        //Scale Up
                        Button {
                            withAnimation(.spring) {
                                if imageScale < 5{
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                            
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                    .opacity(isAnimating ? 1 : 0)
                    
                }.padding(.top)
                , alignment: .bottom
            )
        }//: NAVIGATION
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK - Functions
    func resetImageState() {
        return withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
