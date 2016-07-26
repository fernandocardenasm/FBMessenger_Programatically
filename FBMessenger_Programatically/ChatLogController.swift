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
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.hidden = true
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        collectionView?.registerClass(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat("H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat("V:[v0(40)]", views: messageInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    private func setupInputComponents() {
        messageInputContainerView.addSubview(inputTextField)
        view.addConstraintsWithFormat("H:|-8-[v0]|", views: inputTextField)
        view.addConstraintsWithFormat("V:|[v0]|", views: inputTextField)

    }
    
    func handleKeyBoardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
            bottomConstraint?.constant = -keyboardFrame!.height
        }
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
        
        if let messageText = messages?[indexPath.item].text, profileImageName =  messages?[indexPath.item].friend?.profileImageName{
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            //let size = CGSizeMake(view.frame.width, 1000)
            let size = CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18)], context: nil)
            
            cell.messageTextView.frame = CGRectMake(48 + 8, 0, estimatedFrame.width + 16, estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRectMake(48, 0, estimatedFrame.width + 16 + 8, estimatedFrame.height + 20)

        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            
            //let size = CGSizeMake(view.frame.width, 1000)
            let size = CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18)], context: nil)
            
            return CGSizeMake(view.frame.width, estimatedFrame.height + 20)
        }
        
        return CGSizeMake(view.frame.width, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFontOfSize(18)
        textView.text = "Sample Message"
        textView.backgroundColor = UIColor.clearColor()
        return textView
        
    }()
    
    let textBubbleView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        backgroundColor = UIColor.clearColor()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        addConstraintsWithFormat("H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat("V:[v0(30)]|", views: profileImageView)
        
        profileImageView.backgroundColor = UIColor.redColor()
        
        //Initial constraints for the cells
        /*
        addConstraintsWithFormat("H:|[v0]|", views: messageTextView)
        addConstraintsWithFormat("V:|[v0]|", views: messageTextView)
         */


    }
}
