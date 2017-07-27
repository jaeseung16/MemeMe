//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jae-Seung Lee on 7/27/17.
//  Copyright © 2017 Jae-Seung Lee. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController {
    
    var memes = [Meme]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        
        print("\(self.memes.count)")
        
        self.collectionView.reloadData()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SentMemesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailViewController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell.imageView?.image = meme.memedImage
        
        return cell
    }
}
