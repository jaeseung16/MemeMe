//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Jae-Seung Lee on 6/28/17.
//  Copyright © 2017 Jae-Seung Lee. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
