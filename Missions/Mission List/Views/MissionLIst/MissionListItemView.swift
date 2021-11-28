//
//  MissionListItemView.swift
//  Missions
//
//  Created by nonplus on 11/22/21.
//

import SwiftUI

struct MissionListItemView: View {
    
    @ObservedObject var mission: Mission
    
    var body: some View {
        HStack(
            alignment: .center,
            spacing: 10,
            content: {
                Image(systemName: "note.text")
                    .resizable()
                    .scaledToFit()
                    .padding()
                VStack(
                    alignment: .leading,
                    spacing: 10,
                    content: {
                        Label(
                            title: {
                                Text(mission.title)
                                    .font(.subheadline)
                                    .fontWeight(.black)
                            },
                            icon: {
                                Image(systemName: "list.bullet.below.rectangle")
                                    .foregroundColor(.primary)
                            }
                        ).labelStyle(DefaultLabelStyle())
                        Label(
                            title: {
                                Text(mission.lastUpdatedDate.formatted())
                                    .font(.subheadline)
                                    .fontWeight(.black)
                            },
                            icon: {
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundColor(.primary)
                            }
                        )
                    }
                )
            }
        )
            .frame(height: 64)
    }
}

struct MissionListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MissionListItemView(mission: Mission())
    }
}
