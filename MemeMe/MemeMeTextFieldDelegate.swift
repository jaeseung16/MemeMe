//
//  MemeMeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Jae-Seung Lee on 7/6/17.
//  Copyright © 2017 Jae-Seung Lee. All rights reserved.
//

import Foundation
import UIKit

extension MemeMeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            configure(textField: textField, withString: originalText!, withAttribute: originalTextAttribute!)
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        originalText = textField.text
        originalTextAttribute = textField.defaultTextAttributes
        
        configure(textField: textField, withString: "", withAttribute: memeTextAttribute)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard imagePickerView.image != nil else { return false }
        
        // Estimate the size of newText
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        var newTextAttributes = textField.defaultTextAttributes
        var fontSize = ( newTextAttributes[NSFontAttributeName] as! UIFont ).pointSize
        
        var textSize = newText.size(attributes: newTextAttributes)
        
        // Maimum width of new text
        let maxTextWidth = 0.9 * imageSize().width
        
        if textSize.width < maxTextWidth {
            // Do nothing if newText fits within the maximum width
            return true
        } else {
            // Reduce the font size until newText fits within the maximum width
            while textSize.width >= maxTextWidth {
                fontSize -= 1
                newTextAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: fontSize)!
                textSize = newText.size(attributes: newTextAttributes)
            }

            configure(textField: textField, withString: newText as String, withAttribute: newTextAttributes)
            
            return false
        }
    }
    
}
