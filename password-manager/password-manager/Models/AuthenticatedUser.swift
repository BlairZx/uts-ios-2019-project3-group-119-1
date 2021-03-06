//
//  AuthenticatedUser.swift
//  password-manager
//
//  Created by Ba Tran on 20/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import Foundation
import Firebase

class AuthenticatedUser {
    // Singleton pattern
    private static var _instance: AuthenticatedUser?
    public static var instance: AuthenticatedUser {
        get {
            // Lazy init
            if _instance == nil {
                _instance = AuthenticatedUser()
            }
            return _instance!
        }
        set {
            _instance = newValue
        }
    }
    // End singleton parts
    
    // Observers
    private var observers: [String: AuthenticatedUserObserver] = [:]
    public func addObserver(observer: AuthenticatedUserObserver) -> String {
        let id = NSUUID().uuidString;
        observers[id] = observer
        return id
    }
    public func removeObserver(id: String) {
        observers[id] = nil
    }
    // End observers
    
    
    
    var user: User!
    public var hasSignedIn: Bool {
        get { return user != nil }
    }
    var uidHash: String {
        get { return user.uid.digest.sha256 }
    }
    var dbCredentialsPath: String {
        get { return "Credentials/\(uidHash)" }
    }
    
    private init() {
        observers = [:]
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.user = user
                self.informObserversSignedIn()
            }
        }
    }
    
    private func informObserversSignedIn() {        
        for observer in observers {
            observer.value.onSignedIn()
        }
    }
}

protocol AuthenticatedUserObserver: class {
    func onSignedIn()
}
