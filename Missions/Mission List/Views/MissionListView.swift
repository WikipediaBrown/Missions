//
//  MissionListView.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import Combine
import SwiftUI

struct MissionListView: View {
        
    @ObservedObject var viewModel: ViewModel = ViewModel()
    class ViewModel: ObservableObject {
        @Published var currentMissions: [Mission] = []
        @Published var backlogMissions: [Mission] = []
        @Published var startedMissions: [Mission] = []
        @Published var completeMissions: [Mission] = []
        @Published var removedMissions: [Mission] = []
    }
    
    private var allEmpty: Bool {
        return viewModel.currentMissions.isEmpty
        && viewModel.backlogMissions.isEmpty
        && viewModel.startedMissions.isEmpty
        && viewModel.completeMissions.isEmpty
        && viewModel.removedMissions.isEmpty
    }
    
    var body: some View {
        NavigationView(content: {
            List {
                if viewModel.currentMissions.isEmpty == false, let first = viewModel.currentMissions.first {
                    section(
                        missions: viewModel.currentMissions,
                        headerText: "Current Missions",
                        headerColor: .green,
                        footerText: "Last updated on \(first.lastUpdatedDate.formatted())"
                    )
                }
                if viewModel.backlogMissions.isEmpty == false, let first = viewModel.backlogMissions.first {
                    section(
                        missions: viewModel.backlogMissions,
                        headerText: "Mission Backlog",
                        headerColor: .gray,
                        footerText: "Last updated on \(first.lastUpdatedDate.formatted())"
                    )
                }
                if viewModel.startedMissions.isEmpty == false, let first = viewModel.startedMissions.first {
                    section(
                        missions: viewModel.startedMissions,
                        headerText: "Pending Complete",
                        headerColor: .yellow,
                        footerText: "Last updated on \(first.lastUpdatedDate.formatted())"
                    )
                }
                if viewModel.completeMissions.isEmpty == false, let first = viewModel.completeMissions.first {
                    section(
                        missions: viewModel.completeMissions,
                        headerText: "Mission Complete",
                        headerColor: .blue,
                        footerText: "Last updated on \(first.lastUpdatedDate.formatted())"
                    )
                }
                if viewModel.removedMissions.isEmpty == false {
                    section(
                        missions: viewModel.removedMissions,
                        headerText: "Deleted Missions",
                        headerColor: .red,
                        footerText: "These missions were recently deleted. Missions permanently deleted after 30 days."
                    )
                }
                if allEmpty {
                    Button(
                        action: {
                            self.tapSubject.send(.addMission)
                        },
                        label: {
                            Image(systemName: "plus.app")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.primary)
                            Text("Add a Mission")
                                .foregroundColor(.primary)
                                .fontWeight(.black)
                                .font(.title3)
                        }
                    )
                        .padding()
                } else {
                    Section(footer: MadeInCascadiaView(), content: {})
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Missions")
            .navigationBarItems(
                trailing:
                    Button(
                        action: {
                            tapSubject.send(.addMission)
                        },
                        label: {
                            if !allEmpty {
                            Image(systemName: "plus.square.on.square")
                                .foregroundColor(.primary)
                                .font(.title)
                            }
                        }
                    )
            )
        })
    }
    
    // MARK: - Private Methods
    
    @ViewBuilder private func section(missions: [Mission], headerText: String, headerColor: Color, footerText: String) -> some View {
        Section(
            header: Text(headerText).foregroundColor(headerColor),
            footer: Text(footerText),
            content: {
                ForEach(missions, id: \.lastUpdatedDate) { mission in
                    NavigationLink(
                        destination: { MissionView(mission: mission, tapSubject: tapSubject) },
                        label: { MissionListItemView(mission: mission) }
                    )
                        .swipeActions(edge: .trailing) {
                            Button(
                                role: .destructive,
                                action: {
                                    if mission.missionState == .removed {
                                        tapSubject.send(.deleteMission(uuid: mission.uuid))
                                    } else {
                                        mission.missionState = .removed
                                        tapSubject.send(.update(mission: mission))
                                    }
                                },
                                label: {
                                    Image(systemName: "trash.square.fill")
                                }
                            )
                        }
                }
            }
        )
    }
    
    // MARK: - Taps
    
    let tapSubject: PassthroughSubject<Taps, Never> = PassthroughSubject()

    enum Taps {
        case addMission
        case deleteMission(uuid: UUID)
        case update(mission: Mission)
    }
    
}

struct MissionListView_Previews: PreviewProvider {
    static var previews: some View {
        MissionListView()
    }
}
