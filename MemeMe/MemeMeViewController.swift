//
//  ViewController.swift
//  MemeMe
//
//  Created by Jae-Seung Lee on 6/25/17.
//  Copyright © 2017 Jae-Seung Lee. All rights reserved.
//

import UIKit
import Foundation

class MemeMeViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    
    // MARK: Properties
    
    let memeTextAttribute: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: Float(-2.0)]
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topTextField.defaultTextAttributes = memeTextAttribute
        bottomTextField.defaultTextAttributes = memeTextAttribute
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        self.topTextField.delegate = self.memeTextFieldDelegate
        self.bottomTextField.delegate = self.memeTextFieldDelegate
        
        // Disable the textFields and activityButton at the beginning
        toggleTextField()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
        
        super.viewWillDisappear(animated)
    }
    
    func toggleTextField() {
        topTextField.isEnabled = !topTextField.isEnabled
        bottomTextField.isEnabled = !bottomTextField.isEnabled
        activityButton.isEnabled = !activityButton.isEnabled
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: Actions
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePicker(sourceType: .camera)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func reset(_ sender:Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        toggleTextField()
    }
    
    @IBAction func presentActivityController() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        
        present(activityController, animated: true, completion: reset(_:))
        
        UIImageWriteToSavedPhotosAlbum(meme.memedImage, nil, nil, nil)

    }
    
}

// MARK: UIImagePickerControllerDelegate
extension MemeMeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            picker.dismiss(animated: true, completion: nil)
            
            // Enable textFields
            toggleTextField()
        }

    }
}

// MARK: Methods related to Keyboard
extension MemeMeViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder == true {
            self.view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder == true {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue

        return keyboardSize.cgRectValue.height
    }
    
}

// MARK: Meme object

extension MemeMeViewController {
    func generateMemedImage() -> UIImage {
        
        // Image size to capture
        let actualImageSize = imageSize()

        // Shift the frame of the view for capture
        let frameForCapture = shiftedFrame(for: actualImageSize)
        
        toolBar.isHidden = true
        navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(actualImageSize)
        view.drawHierarchy(in: frameForCapture, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        navigationBar.isHidden = false
        
        return memedImage

    }
    
    func imageSize() -> CGSize {
        let imageSize = imagePickerView.image!.size
        let ratioWidth = imagePickerView.frame.size.width / imageSize.width
        let ratioHeight = imagePickerView.frame.size.height / imageSize.height
        let scale = ratioWidth < ratioHeight ? ratioWidth : ratioHeight
        let actualImageSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        
        return actualImageSize
    }
    
    func shiftedFrame(for imageSize: CGSize) -> CGRect {
        let xOrigin = self.view.frame.origin.x - (self.view.frame.size.width - imageSize.width) * 0.5
        let yOrigin = self.view.frame.origin.y - imagePickerView.frame.origin.y - (imagePickerView.frame.size.height - imageSize.height) * 0.5
        let shiftOrigin = CGPoint(x: xOrigin, y: yOrigin)
        let shiftedFrame = CGRect(origin: shiftOrigin, size: self.view.frame.size)
        
        return shiftedFrame
    }
}
