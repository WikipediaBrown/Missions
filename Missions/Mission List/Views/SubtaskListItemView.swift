//
//  SubtaskListItemView.swift
//  Missions
//
//  Created by nonplus on 11/28/21.
//

import SwiftUI

struct SubtaskListItemView: View {
    
    @ObservedObject var subtask: Subtask

    var body: some View {
        TextField("", text: $subtask.text, prompt: Text("Enter subtask dude"))
    }
}

struct SubtaskListItemView_Previews: PreviewProvider {
    static var previews: some View {
        SubtaskListItemView(subtask: Subtask())
    }
}
