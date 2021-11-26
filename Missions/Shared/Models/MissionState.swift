//
//  MissionState.swift
//  Missions
//
//  Created by nonplus on 11/19/21.
//

import Foundation

@objc
public enum MissionState: Int16, CaseIterable, Hashable {
    case current
    case backlog
    case started
    case complete
    case removed
    
    var title: String {
        switch self {
        case .current: return "Current"
        case .backlog: return "Backlog"
        case .started: return "Started"
        case .complete: return "Complete"
        case .removed: return "Deleted"
        }
    }
}
