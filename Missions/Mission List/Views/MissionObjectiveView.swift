//
//  MissionObjectiveView.swift
//  Missions
//
//  Created by nonplus on 11/28/21.
//

import Combine
import SwiftUI

struct MissionObjectiveView: View {
    
    @ObservedObject var missionObjective: MissionObjective
    @State var showCalendar = false
    
    // MARK: - Taps

    let tapSubject: PassthroughSubject<MissionListView.Taps, Never>

    var body: some View {
        NavigationView {
            Form {
                Section(
                    content: {
                        TextField("", text: $missionObjective.content, prompt: Text("What's the objective Boss?"))
                    },
                    header: {
                        Label("Objective Title", systemImage: "note.text.badge.plus")
                    }
                )
                Section(
                    content: {
                        ToggleListItem(title: "Date",
                                       subtitle: "Today",
                                       imageName: "calendar",
                                       toggleIsOn: $showCalendar.animation()
                        )
                        if showCalendar {
                            DatePicker(
                                    "Start Date",
                                    selection: $missionObjective.scheduledDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.graphical)
                        }
                    },
                    header: {
                        Label("When's it gotta get done?", systemImage: "calendar.badge.plus")
                    }
                )
                Section(
                    content: {
                        if let array = missionObjective.subtasks.array as? [Subtask] {
                            ForEach(
                                array,
                                content: { subtask in
                                    SubtaskListItemView(subtask: subtask)
                                }
                            )
                        }
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
                Section(
                    content: {
                    },
                    footer: {
                        Text("Save this objective to the list.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                )
            }
            .navigationBarTitle(missionObjective.content, displayMode: .large)
        }
        .onDisappear {
            missionObjective.mission?.lastUpdatedDate = Date()
            tapSubject.send(.save)
        }
    }
}

struct MissionObjectiveView_Previews: PreviewProvider {
    static var previews: some View {
        MissionObjectiveView(missionObjective: MissionObjective(), tapSubject: PassthroughSubject<MissionListView.Taps, Never>())
    }
}
