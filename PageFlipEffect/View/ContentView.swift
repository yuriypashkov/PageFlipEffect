//
//  ContentView.swift
//  PageFlipEffect
//
//  Created by Yuriy Pashkov on 13.05.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var progress: CGFloat = 0
    
    var body: some View {
        VStack {
            // main view
            BookView(front: { size in
                 makeFrontView(size)
            }, leftSide: { size in
                makeLeftView()
            }, rightSide: { size in
                makeRightView()
            }, config: BookViewConfig(progress: progress))
            
            // slider and switch-button
            HStack {
                Slider(value: $progress)
                Button("Switch") {
                    withAnimation(.smooth(duration: 1)) {
                        progress = progress == 1.0 ? 0.2 : 1.0
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(16)
            .background(.background, in: .rect(cornerRadius: 16))
            .padding(.top, 48)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.16))
    }
    
    // Main front view
    private func makeFrontView(_ size: CGSize) -> some View {
        Image("bs_first")
            .resizable()
            //.offset(y: 10)
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
    }
    
    // View that showing after main page flip
    private func makeLeftView() -> some View {
        VStack(spacing: 4) {
            Image("bs_left")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(.circle)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
            
            Text("Black Sabbath")
                .font(.system(size: 16, weight: .bold, design: .default))
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }

    // Right view, shows during page flipping
    private func makeRightView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(.system(size: 14))
            Text("Black Sabbath is the debut studio album by English heavy metal band Black Sabbath, released on 13 February 1970 by Vertigo Records in the United Kingdom and on 1 June 1970 by Warner Bros. Records in the United States.")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

#Preview {
    ContentView()
}
