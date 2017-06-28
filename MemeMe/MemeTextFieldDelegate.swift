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
    
    var originalText: String?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.text = originalText
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        originalText = textField.text
        textField.text = ""
    }

}
