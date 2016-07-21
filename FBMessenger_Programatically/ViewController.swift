//
//  ViewController.swift
//  FBMessenger_Programatically
//
//  Created by Fernando Cardenas on 21/07/16.
//  Copyright © 2016 Fernando. All rights reserved.
//

import UIKit


class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.alwaysBounceVertical = true
        collectionView?.registerClass(FriendCell.self, forCellWithReuseIdentifier: cellId)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
        return cell
    }
    
    //Requires to add UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 100)
    }
}

class FriendCell: BaseCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage(named: "zuckprofile")
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dividerLineView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setUpViews() {
        
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[v0(68)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-12-[v0(68)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-82-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : dividerLineView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v0(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : dividerLineView]))
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        backgroundColor = UIColor.redColor()
    }
}
