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
        navigationItem.title = "Recent"
        
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
        
        setupContainerView()
        
        addConstraintsWithFormat("H:|-12-[v0(68)]", views: profileImageView)
        
        //Without Centering
        //addConstraintsWithFormat("V:|-12-[v0(68)]", views: profileImageView)
        
        //When Centering is used
        addConstraintsWithFormat("V:[v0(68)]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        
        addConstraintsWithFormat("H:|-82-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.redColor()
        addSubview(containerView)
        
        addConstraintsWithFormat("H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat("V:[v0(60)]", views: containerView)
        
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
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

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}
