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
    
    @EnvironmentObject var addMissionViewModel: AddMissionView.ViewModel
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: ViewModel = ViewModel()
    class ViewModel: ObservableObject, Identifiable {
        @Published var title = ""
        @Published var date = Date()
        @Published var subtasks: [String]  = []
        @Published var showCalendar = false
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    content: {
                        TextField("", text: $viewModel.title, prompt: Text("What's the objective Boss?"))
                    },
                    header: {
                        Label("Objective Summary", systemImage: "note.text.badge.plus")
                    }
                )
                Section(
                    content: {
                        ToggleListItem(title: "Date",
                                       subtitle: "Today",
                                       imageName: "calendar",
                                       toggleIsOn: $viewModel.showCalendar.animation()
                        )
                        if viewModel.showCalendar {
                            DatePicker(
                                    "Start Date",
                                    selection: $viewModel.date,
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
                            viewModel.subtasks.indices,
                            id: \.self,
                            content: { index in
                                TextField("", text: $viewModel.subtasks[index], prompt: Text("Enter subtask dude"))
                            }
                        )
                            .onDelete { viewModel.subtasks.remove(atOffsets: $0) }
                            
                        Button(
                            action: {
                                if viewModel.subtasks.last != "" {
                                    withAnimation {
                                        viewModel.subtasks.append("")
                                    }
                                }
                            },
                            label: {
                                Label("Add a Subtask", systemImage: "plus.square.on.square")
                            }
                        )
                    },
                    header: {
                        Label("Objective Subtasks", systemImage: "list.dash")
                    },
                    footer: {
                        Text("Add some subtasks if you need more direction...")
                    }
                )
                Section(
                    content: {
                        Button(
                            action: {
                                viewModel.subtasks = viewModel.subtasks.filter { $0.isEmpty }
                                addMissionViewModel.currentObjectives.append(viewModel)
                                presentationMode.wrappedValue.dismiss()
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
