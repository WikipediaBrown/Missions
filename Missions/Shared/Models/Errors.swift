//
//  Errors.swift
//  Missions
//
//  Created by nonplus on 11/21/21.
//

import Foundation

enum CoreDataError: Error {
    case cannotAccessManagedContext
    case codingUserInfoKeyError
    case entityDescriptionError
    case cannotRecognizeObject
}
