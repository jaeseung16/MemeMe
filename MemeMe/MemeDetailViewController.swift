//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jae-Seung Lee on 7/26/17.
//  Copyright © 2017 Jae-Seung Lee. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView.image = meme.memedImage
    }


}
