//
//  AuthenticationManager.swift
//  Missions
//
//  Created by nonplus on 1/15/22.
//

import Combine
import FirebaseAuth

protocol AuthenticationManaging {
    var userPublisher: CurrentValueSubject<Auth?, Never> { get }
}

class AuthenticationManager: AuthenticationManaging {
    
    let userPublisher = CurrentValueSubject<Auth?, Never>(nil)
    
    private var authStateHandler: AuthStateDidChangeListenerHandle? = nil
    
    init() {
        authStateHandler = Auth.auth().addStateDidChangeListener(authStateBlock)
    }
    
    func login() {}
    
    private func authStateBlock(auth: Auth, user: User?) {
        switch user {
        case .some(_): userPublisher.send(auth)
        case .none: userPublisher.send(nil)
        }
    }
}
