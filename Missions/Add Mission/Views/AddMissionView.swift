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
        @Published var name = ""
        @Published var showAddObjectiveView = false
        @Published var currentMissions: [AddObjectiveView.ViewModel] = []
    }

    var body: some View {
        NavigationView {
            Form {
                Section(
                    content: {
                        TextField("Mission Name", text: $viewModel.name, prompt: Text("Enter mission name..."))
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
                        Button(
                            action: {
                                viewModel.showAddObjectiveView.toggle()
                            },
                            label:   {
                                Label("Add Objective", systemImage: "list.dash")
                            }
                        )
                        .buttonStyle(ButtonModifier(color: .indigo))
                        .sheet(
                            isPresented: $viewModel.showAddObjectiveView,
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
                                tapSubject.send(.addMission(name: viewModel.name))
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
        case addMission(name: String)
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
