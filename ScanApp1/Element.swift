//
//  Element.swift
//  ScanApp1
//
//  Created by Raphael on 2020/10/17.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit

class Element: NSObject {

    var userName: String?
    var company: String?
    var imageString: String?
    var memo: String?
    var createAt:CLong?
    
    init(userName: String, company: String, imageString: String, memo: String, createAt: CLong){
        
        self.userName = userName
        self.company = company
        self.imageString = imageString
        self.memo = memo
        self.createAt = createAt
    }
    
}
