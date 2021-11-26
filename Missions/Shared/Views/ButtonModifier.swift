//
//  ButtonModifier.swift
//  Missions
//
//  Created by nonplus on 11/21/21.
//

import SwiftUI

struct ButtonModifier: ButtonStyle {
    
    let color: Color
    let height: CGFloat
    
    init(color: Color, height: CGFloat = 44) {
        self.color = color
        self.height = height
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack(alignment: .center,
               content: {
                color
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                configuration.label
                    .foregroundColor(.white)
                    .font(.system(size: UIFont.buttonFontSize,
                                  weight: .heavy,
                                  design: .rounded)
                    )
               })
            .frame(height: height)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: configuration.isPressed)
//
    }
}
