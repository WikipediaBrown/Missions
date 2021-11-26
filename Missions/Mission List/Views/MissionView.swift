//
//  MissionView.swift
//  Missions
//
//  Created by nonplus on 11/22/21.
//

import Combine
import SwiftUI

struct MissionView: View {
    
    @State var mission: Mission
    
    var body: some View {
        
        List {
            Section(
                content: {
                    TextField("Mission Name", text: $mission.name, prompt: Text("Enter mission name..."))
                },
                header: {
                    Text("Mission Name")
                }
            )
            Section(
                content: {
                    Picker(
                        selection: $mission.missionState,
                        content: {
                            ForEach(
                                MissionState.allCases,
                                id: \.self,
                                content: {
                                    Text($0.title)
                                        .minimumScaleFactor(0.2)
                                }
                            )
                        },
                        label: {}
                    )
                    
                        .pickerStyle(.segmented)
                },
                header: {
                    Text("Status")
                },
                footer: {
                    Text("Mission Name")
                }
            )
            Section {
                Button(
                    action: {
                        mission.lastUpdatedDate = Date()
                        tapSubject.send(.update(mission: mission))
                    },
                    label:   {
                        Label("Update Mission", systemImage: "square.and.arrow.down.fill")
                    }
                )
                    .buttonStyle(ButtonModifier(color: .green))
                Button(
                    role: .destructive,
                    action: {
                        mission.lastUpdatedDate = Date()
                        mission.missionState = .removed
                        tapSubject.send(.update(mission: mission))
                    },
                    label:   {
                        Label("Delete Mission", systemImage: "trash")
                    }
                )
                    .buttonStyle(ButtonModifier(color: .red))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(Text(mission.name))
    }
    
    // MARK: - Taps

    let tapSubject: PassthroughSubject<MissionListView.Taps, Never>

}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        MissionView(mission: Mission(), tapSubject: PassthroughSubject<MissionListView.Taps, Never>())
    }
}
