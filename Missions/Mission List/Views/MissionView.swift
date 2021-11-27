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
                    TextField("Mission Name", text: $mission.title, prompt: Text("Enter mission name..."))
                },
                header: {
                    Text("Mission Name")
                }
            )
            Section(
                content: {
                    TextEditor(text: $mission.summary)
                },
                header: {
                    Text("Mission Summary")
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
            Section(
                content: {
//                    ForEach(
//                        mission.subtasks.indices,
//                        id: \.self,
//                        content: { index in
//                            TextField("", text: $mission.subtasks[index].text, prompt: Text("Enter subtask dude"))
//                        }
//                    )
//                        .onDelete { mission.subtasks.remove(atOffsets: $0) }
                        
//                    Button(
//                        action: {
//                            if viewModel.subtasks.last != "" {
//                                withAnimation {
//                                    viewModel.subtasks.append("")
//                                }
//                            }
//                        },
//                        label: {
//                            Label("Add a Subtask", systemImage: "plus.square.on.square")
//                        }
//                    )
                },
                header: {
                    Label("Objective Subtasks", systemImage: "list.dash")
                },
                footer: {
                    Text("Add some subtasks if you need more direction...")
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
        .navigationTitle(Text(mission.title))
    }
    
    // MARK: - Taps

    let tapSubject: PassthroughSubject<MissionListView.Taps, Never>

}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        MissionView(mission: Mission(), tapSubject: PassthroughSubject<MissionListView.Taps, Never>())
    }
}
