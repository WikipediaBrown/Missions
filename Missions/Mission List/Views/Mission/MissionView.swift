//
//  MissionView.swift
//  Missions
//
//  Created by nonplus on 11/22/21.
//

import Combine
import SwiftUI

struct MissionView: View {
    
    @ObservedObject var mission: Mission

    @State var showNewMissionObjectiveView = false
    @State var update: Bool = false
    
    // MARK: - Taps

    let tapSubject: PassthroughSubject<MissionListView.Taps, Never>
    
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
                    ForEach(
                        mission.objectives.array as? [MissionObjective] ?? [],
                        id: \.uuid,
                        content: { missionObjective in
                            NavigationLink(
                                destination: { MissionObjectiveView(missionObjective: missionObjective, tapSubject: tapSubject) },
                                label: { MissionObjectiveListItemView(missionObjective: missionObjective) }
                            )
                        }
                    )
                    .onDelete(perform: { indexSet in
                        let objectives = indexSet.compactMap { mission.objectives.array[$0] as? MissionObjective }
                        objectives.forEach { tapSubject.send(.deleteMissionObjective(uuid: $0.uuid)) }
                    })
                    .onMove { indexSet, index in
                        
                        guard let objectives = mission.objectives.mutableCopy() as? NSMutableOrderedSet
                        else { return }
                        var index = index
                        
                        if index < 0 {
                            index = 0
                        }
                        else if index >= mission.objectives.count {
                            index = mission.objectives.count - 1
                        }
                        
                        objectives.moveObjects(at: indexSet, to: index)
                        mission.objectives = objectives
                        mission.objectWillChange.send()
                        tapSubject.send(.update(mission: mission))
                        
                    }
//                    Button(
//                        action: {
//                            showNewMissionObjectiveView.toggle()
//                        },
//                        label: {
//                            Label("Add Objective", systemImage: "list.dash")
//                        }
//                    )
//                        .buttonStyle(ButtonModifier(color: .indigo))
//                        .sheet(
//                            isPresented: $showNewMissionObjectiveView,
//                            onDismiss: {},
//                            content: {
//                                NewMissionObjectiveView()
//                            }
//                        )
                },
                header: {
                    EditButton()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .overlay(Label("Objective Subtasks", systemImage: "list.dash"), alignment: .leading)
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
        .navigationBarTitle("Mission", displayMode: .large)
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.large)
        .onDisappear {
            mission.lastUpdatedDate = Date()
            tapSubject.send(.save)
        }
    }
    
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        MissionView(mission: Mission(), tapSubject: PassthroughSubject<MissionListView.Taps, Never>())
    }
}
