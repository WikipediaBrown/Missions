//
//  AuthenticationManager.swift
//  Missions
//
//  Created by nonplus on 1/15/22.
//

import AuthenticationServices
import Combine
import CryptoKit
import Firebase
import FirebaseAuth

protocol AuthenticationManaging {
    var userSubject: PassthroughSubject<User?, Error> { get }
    func signIn()
    func signOut()
}

class AuthenticationManager: NSObject, AuthenticationManaging {
    
    // MARK: - Public Properties
    
    let userSubject = PassthroughSubject<User?, Error>()
    
    // MARK: - Private Properties
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?
    private var window: UIWindow

    // MARK: - Initializers
    
    init(window: UIWindow) {
        self.window = window
        super.init()
        self.authHandle = Auth.auth().addStateDidChangeListener(authStateDidChange)
    }
    
    // MARK: - Public Methods
        
    func signIn() {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            userSubject.send(completion: .failure(error))
        }
    }
    
    // MARK: - Private Methods
    
    private func authStateDidChange(auth: Auth, user: User?) {
        userSubject.send(user)
    }
    
    private func signInComplete(authDataResult: AuthDataResult?, error: Error?) {
        if let error = error { userSubject.send(completion: .failure(error)) }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthenticationManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard
                let identityToken = appleIDCredential.identityToken,
                let token = String(data: identityToken, encoding: .utf8),
                let nonce = currentNonce
            else { return }
            
            let id = Constants.Strings.appleProviderID
            let credential = OAuthProvider.credential(withProviderID: id, idToken: token, rawNonce: nonce)
            Auth.auth().signIn(with: credential, completion: signInComplete)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        userSubject.send(completion: .failure(error))
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthenticationManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
}

// MARK: - Extension for `randomNonceString` method. This method generates a nonce.

extension AuthenticationManager {
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    // From https://firebase.google.com/docs/auth/ios/apple?authuser=0
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
