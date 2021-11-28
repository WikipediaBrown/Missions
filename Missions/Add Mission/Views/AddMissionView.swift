//
//  AddMissionView.swift
//  Missions
//
//  Created by nonplus on 7/21/21.
//

import Combine
import SwiftUI

struct AddMissionView: View {
            
    @ObservedObject var viewModel: ViewModel = ViewModel()
    class ViewModel: ObservableObject {
        @Published var title = ""
        @Published var summary = ""
        @Published var currentObjectives: [AddObjectiveView.ViewModel] = []
    }

    @State var showAddObjectiveView = false

    var body: some View {
        NavigationView {
            Form {
                Section(
                    content: {
                        TextField("Mission Name", text: $viewModel.title, prompt: Text("Enter mission name..."))
                    },
                    header: {
                        Text("Mission Name")
                    },
                    footer: {
                        Text("Enter the mission name and make it somethin' friggin' cool.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                )
                Section(
                    content: {
                        TextEditor(text: $viewModel.summary)
                    },
                    header: {
                        Text("Mission Summary")
                    },
                    footer: {
                        Text("Write down the rundown. If you want...")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                )
                Section(
                    content: {
                        ForEach(
                            $viewModel.currentObjectives,
                            content: { objective in
                                Text(objective.title.wrappedValue)
                            }
                        )
                            .onDelete { viewModel.currentObjectives.remove(atOffsets: $0) }
                        Button(
                            action: {
                                showAddObjectiveView.toggle()
                            },
                            label:   {
                                Label("Add Objective", systemImage: "list.dash")
                            }
                        )
                        .buttonStyle(ButtonModifier(color: .indigo))
                        .sheet(
                            isPresented: $showAddObjectiveView,
                            onDismiss: {},
                            content: {
                                AddObjectiveView()
                            }
                        )
                    },
                    header: {
                        Text("Mission Objectives")
                    },
                    footer: {
                        Text("Enter the mission name and make it somethin' friggin' cool.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                )
                Section(
                    content: {
                        Button(
                            action: {
                                tapSubject.send(.addMission(name: viewModel.title,
                                                            summary: viewModel.summary,
                                                            objectives: viewModel.currentObjectives)
                                )
                            },
                            label:   {
                                Label("Save Mission", systemImage: "square.and.arrow.down")
                            }
                        )
                        .buttonStyle(ButtonModifier(color: .green))
                    },
                    footer: {
                        Text("Enter the mission name & make it somethin' friggin' cool.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                )
                
            }
            .navigationBarTitle("Create a Mission", displayMode: .large)
        }
        .environmentObject(viewModel)
    }
    
    // MARK: - Tap Subject
    
    let tapSubject: PassthroughSubject<Taps, Never> = PassthroughSubject()

    enum Taps {
        case addMission(name: String, summary: String, objectives: [AddObjectiveView.ViewModel])
        case dismiss
    }
    
    enum Focused: Int, Hashable {
        case name
    }
}

struct AddMissionView_Previews: PreviewProvider {
    static var previews: some View {
        AddMissionView()
    }
}
