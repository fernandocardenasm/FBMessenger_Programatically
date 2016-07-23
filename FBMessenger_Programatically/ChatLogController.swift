//
//  ChatLogController.swift
//  FBMessenger_Programatically
//
//  Created by Fernando Cardenas on 23/07/16.
//  Copyright © 2016 Fernando. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var friend: Friend? {
        didSet{
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
            messages = messages?.sort({$0.date!.compare($1.date!) == .OrderedAscending})

        }
    }
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        collectionView?.registerClass(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView.text = messages?[indexPath.item].text
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 100)
    }
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFontOfSize(16)
        textView.text = "Sample Message"
        return textView
        
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(messageTextView)
        addConstraintsWithFormat("H:|[v0]|", views: messageTextView)
        addConstraintsWithFormat("V:|[v0]|", views: messageTextView)


    }
}
