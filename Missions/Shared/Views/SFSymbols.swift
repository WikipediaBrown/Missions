//
//  SFSymbols.swift
//  Missions
//
//  Created by nonplus on 12/18/21.
//

import UIKit

extension UIImage {
    static let this = getSystemImage(named: <#T##String#>)
    
    static func getSystemImage(named: String) -> UIImage {
        guard let image = UIImage(systemName: named)
        else { fatalError("Could Not Find System Image") }
        return image
    }
}
