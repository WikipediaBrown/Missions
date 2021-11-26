//
//  AddObjectiveView.swift
//  Missions
//
//  Created by nonplus on 11/24/21.
//

import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

struct AddObjectiveView: View {
    
    @State var summary = ""
    @State var date = Date()
    @State var subtasks: [String]  = []
    @State var showCalendar = false

    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    content: {
                        TextEditor(text: $summary)
                            .frame(height: 128)
                    },
                    header: {
                        Text("Objective Summary")
                    }
                )
                Section(
                    content: {
                        ToggleListItem(title: "Date",
                                       subtitle: "Today",
                                       imageName: "calendar",
                                       toggleIsOn: $showCalendar
                        )
                        if showCalendar {
                            DatePicker(
                                    "Start Date",
                                    selection: $date,
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
                        ForEach(
                            subtasks.indices,
                            id: \.self,
                            content: { index in
                                TextField("", text: $subtasks[index], prompt: Text("Enter a subtask my dude"))
                                
                            }
                        )
                            .onDelete { indexSet in
                                subtasks.remove(atOffsets: indexSet)
                            }
                        Button(
                            action: {
                                if subtasks.last != "" {
                                    subtasks.append("")
                                }
                            },
                            label: {
                                Label("Add a Subtask", systemImage: "plus.square.on.square")
                            }
                        )
                    },
                    header: {
                        Text("Objective Subtasks")
                    },
                    footer: {
                        Text("Add some subtasks if you need more direction...")
                    }
                )
                Section(
                    content: {
                        Button(
                            action: {

                            },
                            label:   {
                                Label("Save Objective", systemImage: "square.and.arrow.down")
                            }
                        )
                        .buttonStyle(ButtonModifier(color: .green))
                    },
                    footer: {
                        Text("Save this objective to the list.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                )
            }
            .navigationBarTitle("Add an Objective", displayMode: .large)
        }
    }
}

struct AddObjectiveView_Previews: PreviewProvider {
    static var previews: some View {
        AddObjectiveView()
    }
}
