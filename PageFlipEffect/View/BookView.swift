//
//  BookView.swift
//  PageFlipEffect
//
//  Created by Yuriy Pashkov on 13.05.2024.
//

import SwiftUI

struct BookView<Front: View, LeftSide: View, RightSide: View>: View, Animatable {
    
    var front: (CGSize) -> Front
    var leftSide: (CGSize) -> LeftSide
    var rightSide: (CGSize) -> RightSide
    
    var config: BookViewConfig = BookViewConfig()
    
    // fix animation glitch after switch-button tap
    var animatableData: CGFloat {
        get { config.progress }
        set { config.progress = newValue }
    }
    
    var body: some View {
        GeometryReader { reader in
            // calculate need values
            let size = reader.size
            let progress = max(min(config.progress, 1), 0)
            let rotation = -180 * progress
            let radius = config.cornerRadius
            
            ZStack {
                rightSide(size)
                    .frame(width: size.width, height: size.height)
                    // page separator
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(.gray.opacity(0.16))
                            .frame(width: 4)
                            .offset(x: -2)
                            .clipped()
                    }
                    .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: radius, topTrailingRadius: radius, style: .circular))
                    .shadow(color: .black.opacity(0.1 * progress), radius: 5, x: 5, y: 0)
                
                front(size)
                    .frame(width: size.width, height: size.height)
                    .allowsHitTesting(-rotation < 90)
                    // replace front view during page flip
                    .overlay{
                        if -rotation > 90 {
                            leftSide(size)
                                .frame(width: size.width, height: size.height)
                                .scaleEffect(x: -1)
                                .transition(.identity)
                        }
                    }
                    .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: radius, topTrailingRadius: radius, style: .circular))
                    // main rotation effect with leading-anchor and changing perspective
                    .rotation3DEffect(
                        .degrees(rotation),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        perspective: 0.3
                    )
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 0)
            }
            // set view on center during flipping
            .offset(x: (config.width / 2) * progress)
        }
        .frame(width: config.width, height: config.height)
    }
}
