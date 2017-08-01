//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Jae-Seung Lee on 7/25/17.
//  Copyright © 2017 Jae-Seung Lee. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes = [Meme]()
    
    let memeTextAttributes: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 24)!,
        NSStrokeWidthAttributeName: Float(-2.0)]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memes = loadSentMemes()
        
        self.tableView.reloadData()
    }
    
    func loadSentMemes() -> [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableViewCell", for: indexPath) as! SentMemeTableViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        configure(label: cell.topLabel, withString: meme.topText, withAttribute: memeTextAttributes)
        configure(label: cell.bottomLabel, withString: meme.bottomText, withAttribute: memeTextAttributes)
        
        cell.topBottomLabel.text = meme.topText + "..." + meme.bottomText
        
        cell.memeImageView.image = meme.originalImage

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailViewController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    func configure(label: UILabel, withString text: String, withAttribute textAttributes: [String: Any]) {
        label.attributedText = NSAttributedString(string: text, attributes: textAttributes)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
    }

}
