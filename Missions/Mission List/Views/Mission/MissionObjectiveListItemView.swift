//
//  MissionObjectiveListItemView.swift
//  Missions
//
//  Created by nonplus on 11/28/21.
//

import SwiftUI

struct MissionObjectiveListItemView: View {
    
    @ObservedObject var missionObjective: MissionObjective

    var body: some View {
        Text(missionObjective.content)
    }
}

struct MissionObjectiveListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MissionObjectiveListItemView(missionObjective: MissionObjective())
    }
}
