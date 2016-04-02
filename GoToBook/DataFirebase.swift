//
//  DataFirebase.swift
//  GoToBook
//
//  Created by Nurzhan Sagyndyk on 02.04.16.
//  Copyright © 2016 Nurzhan Sagyndyk. All rights reserved.
//

import Foundation
import Firebase

class DataFirebase {
    static let dataService = DataFirebase()
    
    private var _BASE_REF = Firebase(url: "https://gotobook.firebaseio.com/")
    private var _USER_REF = Firebase(url: "https://gotobook.firebaseio.com/users")
    private var _JOKE_REF = Firebase(url: "https://gotobook.firebaseio.com/books")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
}
