//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jae-Seung Lee on 7/27/17.
//  Copyright © 2017 Jae-Seung Lee. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController {
    
    // MARK: Properties
    var memes = [Meme]()
    
    let memeTextAttributes: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 24)!,
        NSStrokeWidthAttributeName: Float(-2.0)]
    
    let space: CGFloat = 3.0
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memes = loadSentMemes()
        
        self.collectionView.reloadData()
        
        adjustFlowLayoutSize(size: self.view.frame.size)
    }

    func loadSentMemes() -> [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

}

// MARK: CollectionView Deleagte & DataSource

extension SentMemesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell.imageView?.image = meme.originalImage
        configure(label: cell.topLabel, withString: meme.topText, withAttribute: memeTextAttributes)
        configure(label: cell.bottomLabel, withString: meme.bottomText, withAttribute: memeTextAttributes)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailViewController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    func configure(label: UILabel, withString text: String, withAttribute textAttributes: [String: Any]) {
        label.attributedText = NSAttributedString(string: text, attributes: textAttributes)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // This method is called when the orientaition of a device changes even before the view controller is loaded.
        // So checking whether flowLayout exists before updating the collection view
        if self.flowLayout != nil {
            self.flowLayout.invalidateLayout()
            adjustFlowLayoutSize(size: size)
        }
    }
    
    func adjustFlowLayoutSize(size: CGSize) {
        let dimension = cellSize(size: size, space: self.space)
        
        self.flowLayout.minimumInteritemSpacing = self.space
        self.flowLayout.minimumLineSpacing = self.space
        self.flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func cellSize(size: CGSize, space: CGFloat) -> CGFloat {
        let height = size.height
        let width = size.width
        
        let numberInRow = height > width ? CGFloat(3.0) : CGFloat(5.0)
        
        return ( width - 2.0 * space ) / numberInRow
    }
}
