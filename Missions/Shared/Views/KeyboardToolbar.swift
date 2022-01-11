//
//  KeyboardToolbar.swift
//  Missions
//
//  Created by nonplus on 12/18/21.
//

import SwiftUI

struct KeyboardToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItemGroup(
            placement: .keyboard,
            content: {
//                let activeImage = UIImage(
//                KeyboardToolbarButton(
//                    tapped: <#T##(Bool) -> Void#>,
//                    activeImage: <#T##UIImage#>,
//                    deactiveImage: <#T##UIImage#>,
//                    isPressed: <#T##Binding<Bool>#>)
            }
        )
    }
}

struct KeyboardToolbarButton: View {
    
    let tapped: (Bool) -> Void
    let activeImage: UIImage
    let deactiveImage: UIImage
    
    @Binding var isPressed: Bool

    var body: some View {
        Button(
            action: {
                isPressed.toggle()
                tapped(isPressed)
            },
            label: {
                if isPressed {
                    Image(uiImage: activeImage)
                } else {
                    Image(uiImage: deactiveImage)
                }
            }
        )
            .buttonStyle(ToggleButtonModifier(isPressed: $isPressed))
    }
}
