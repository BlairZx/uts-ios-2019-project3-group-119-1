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
    var user: User!
    init() {
        signInTest()
    }
    func signInTest() {
        Auth.auth().signIn(withEmail: "test@test.com", password: "testtest", completion: {(r,e) in
            if let result = r {
                print("user: \(result.user.uid)")
                self.user = result.user
            }
            if let error = e {
                print("error: \(error.localizedDescription)")
            }
        })
    }
}
