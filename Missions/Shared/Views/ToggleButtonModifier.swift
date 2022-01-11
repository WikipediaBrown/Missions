//
//  ToggleButtonModifier.swift
//  Missions
//
//  Created by nonplus on 12/18/21.
//

import SwiftUI

struct ToggleButtonModifier: ButtonStyle {
    
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed, perform: { newValue in
                isPressed = newValue
            })
    }
}
