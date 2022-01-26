//
//  Optional.swift
//  Missions
//
//  Created by nonplus on 1/25/22.
//

import Foundation

extension Optional {
    var exists: Bool {
        switch self {
        case .some(_): return true
        case .none: return false
        }
    }
}
