//
//  Image.swift
//  Missions
//
//  Created by nonplus on 11/21/21.
//

import SwiftUI

// From the StackOverflow answer detailed here: https://stackoverflow.com/a/59534345/5863650 This protocol and extenstion allows us to use `ImageModifier` like `ViewModifier`.

// MARK: - ImageModifier

protocol ImageModifier {
    /// `Body` is derived from `View`
    associatedtype Body : View

    /// Modify an image by applying any modifications into `some View`
    func body(image: Image) -> Self.Body
}

extension Image {
    func modifier<M>(_ modifier: M) -> some View where M: ImageModifier {
        modifier.body(image: self)
    }
}
