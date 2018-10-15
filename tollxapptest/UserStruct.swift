//
//  UserStruct.swift
//  tollxapptest
//
//  Created by Kevin Abram on 8/16/17.
//  Copyright © 2017 Binus. All rights reserved.
//

import Foundation
class maininfo: ViewController{
public struct userinfo {
    var firstname: String
    var lastname: String
    var email: String
    var pass: String
    var dob: String
    var phone: Int
    static var userarray = [userinfo]()
    init(firstname: String, lastname: String, email: String, pass: String, dob: String, phone: Int)
    {
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.pass = pass
        self.dob = dob
        self.phone = phone
        
        
        
    }
        func add(theuser: userinfo)
        {
            userinfo.userarray.append(theuser)
        }
    
    
    
    }
    
}
