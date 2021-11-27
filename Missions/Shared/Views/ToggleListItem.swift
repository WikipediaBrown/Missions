//
//  DefaultListItem.swift
//  Missions
//
//  Created by nonplus on 11/25/21.
//

import SwiftUI

struct ToggleListItem: View {
    
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var imageName: String = ""
    @State var toggleMessage: String = ""
    @State var color: UIColor = .systemRed
    
    var toggleIsOn: Binding<Bool>
    
    var body: some View {
        HStack(
            alignment: .center,
            spacing: 10,
            content: {
                ZStack(
                    alignment: .center,
                    content: {
                        Color(color)
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(6)
                    }
                )
                    .frame(width: 38, height: 38)
                    .cornerRadius(5)
                VStack(
                    alignment: .leading,
                    spacing: 3,
                    content: {
                        Text(title)
                            .font(.callout)
                            .fontWeight(.semibold)
                        Text(subtitle)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.accentColor)
                    }
                )
                    .padding()
                Spacer()
                Toggle(toggleMessage, isOn: toggleIsOn.animation(.spring()))
                    .padding()
            }
        )
    }
    
}

struct DefaultListItem_Previews: PreviewProvider {
    static var previews: some View {
        ToggleListItem(toggleIsOn: Binding<Bool>(get: { true }, set: {_ in }))
    }
}
