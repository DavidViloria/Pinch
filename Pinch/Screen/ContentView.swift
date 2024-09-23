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
    @State private var isDrawerOpen: Bool = false
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.clear
                Image(currentPage())
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
                
                //: MARK - Magnification
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5{
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                            .onEnded({ _ in
                                if imageScale > 5{
                                    imageScale = 5
                                } else if imageScale <= 1{
                                    imageScale = 1
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
            
            //: MARK: Drawer
            .overlay (
                HStack(spacing: 12){
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    // MARK: Thumbnails
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(pages) { page in
                                Image(page.thumbnailName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80)
                                    .cornerRadius(8)
                                    .shadow(radius: 4)
                                    .opacity(isDrawerOpen ? 1 : 0)
                                    .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                                    .onTapGesture {
                                        withAnimation(.easeIn) {
                                            pageIndex = page.id
                                        }
                                    }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: isDrawerOpen ? 10 : 220),
                alignment: Alignment(horizontal: .trailing, vertical: .top)
                
                
                
            )//: Drawer
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
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
