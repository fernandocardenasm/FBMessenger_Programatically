//
//  ChatLogController.swift
//  FBMessenger_Programatically
//
//  Created by Fernando Cardenas on 23/07/16.
//  Copyright © 2016 Fernando. All rights reserved.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    let cellId = "cellId"
    
    var friend: Friend? {
        didSet{
            navigationItem.title = friend?.name
        }
    }
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Send", forState: .Normal)
        let titleColor = UIColor.rgb(0, green: 139, blue: 249)
        button.setTitleColor(titleColor, forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        
        button.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultController.performFetch()
        }
        catch let err {
            print(err)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .Plain, target: self, action: #selector(simulate))
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleSend() {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        if let inputText = inputTextField.text {
            if !inputText.isEmpty {
                FriendsController.createMessageWithText(inputText, friend: friend!, minutesAgo: 0, context: context, isSender: true)
                
                do {
                    try context.save()
                    inputTextField.text = nil
                    
                } catch let err {
                    print(err)
                }
            }
            
        }
        
        
    }
    
    func simulate() {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        FriendsController.createMessageWithText("No puede ser vacio", friend: friend!, minutesAgo: 2, context: context)
        FriendsController.createMessageWithText("Another message that was added.", friend: friend!, minutesAgo: 2, context: context)

        do {
            try context.save()
            
        } catch let err {
            print(err)
        }
    }
    
    lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    //Solve to add two messages at the same time
    var blockOperations = [NSOperation]()
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Insert {
            if let indexPath = newIndexPath {
                
                blockOperations.append(NSBlockOperation(block: {
                    self.collectionView?.insertItemsAtIndexPaths([indexPath])
                }))
                
                //collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView?.performBatchUpdates({
            
            for operation in self.blockOperations {
                operation.start()
            }
            
            }, completion: { (completed) in
                
                let lastItem = self.fetchedResultController.sections![0].numberOfObjects - 1
                let indexPath = NSIndexPath(forItem: lastItem, inSection: 0)
                self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        })
    }
    
    private func setupInputComponents() {
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstraintsWithFormat("H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstraintsWithFormat("H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0(0.5)]", views: topBorderView)

    }
    
    func handleKeyBoardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
            
            let isKeyBoardShowing = notification.name == UIKeyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyBoardShowing ? -keyboardFrame!.height : 0
            
            UIView.animateWithDuration(0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    
                    if isKeyBoardShowing {
                        let lastItem = self.fetchedResultController.sections![0].numberOfObjects - 1
                        let indexPath = NSIndexPath(forItem: lastItem, inSection: 0)
                        self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                    }
            })
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        inputTextField.endEditing(true)
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = fetchedResultController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatLogMessageCell
        
        
        if let message = fetchedResultController.objectAtIndexPath(indexPath) as? Message, messageText = message.text, profileImageName =  message.friend?.profileImageName {
  
            cell.messageTextView.text = message.text

            cell.profileImageView.image = UIImage(named: profileImageName)
            //let size = CGSizeMake(view.frame.width, 1000)
            let size = CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18)], context: nil)
            
            if let bool = message.isSender?.boolValue {
                if !bool {
                    cell.messageTextView.frame = CGRectMake(48 + 8, 0, estimatedFrame.width + 16, estimatedFrame.height + 20)
                    cell.textBubbleView.frame = CGRectMake(48 - 10, -4, estimatedFrame.width + 16 + 8 + 16, estimatedFrame.height + 20 + 6)
                    cell.profileImageView.hidden = false
                    
                    cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                    cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                    cell.messageTextView.textColor = UIColor.blackColor()
                }
                else {
                    cell.messageTextView.frame = CGRectMake(view.frame.width - estimatedFrame.width - 16 - 16 - 8, 0, estimatedFrame.width + 16, estimatedFrame.height + 20)
                    cell.textBubbleView.frame = CGRectMake(view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, -4, estimatedFrame.width + 16 + 8 + 10, estimatedFrame.height + 20 + 6)
                    
                    cell.profileImageView.hidden = true
                    
                    cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                    cell.bubbleImageView.tintColor = UIColor.rgb(0, green: 137, blue: 249)
                    cell.messageTextView.textColor = UIColor.whiteColor()
                }
                
            }

        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let message = fetchedResultController.objectAtIndexPath(indexPath) as? Message, messageText = message.text {
            
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
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImageWithCapInsets(UIEdgeInsetsMake(22, 26, 22, 26)).imageWithRenderingMode(.AlwaysTemplate)
    
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImageWithCapInsets(UIEdgeInsetsMake(22, 26, 22, 26)).imageWithRenderingMode(.AlwaysTemplate)
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFontOfSize(18)
        textView.text = "Sample Message"
        textView.editable = false
        textView.backgroundColor = UIColor.clearColor()
        return textView
        
    }()
    
    let textBubbleView: UIView = {
       let view = UIView()
        //view.backgroundColor = UIColor(white: 0.95, alpha: 1)
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
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatLogMessageCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
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
        
        textBubbleView.addSubview(bubbleImageView)
        
        textBubbleView.addConstraintsWithFormat("H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat("V:|[v0]|", views: bubbleImageView)
        
        //Initial constraints for the cells
        /*
        addConstraintsWithFormat("H:|[v0]|", views: messageTextView)
        addConstraintsWithFormat("V:|[v0]|", views: messageTextView)
         */


    }
}
