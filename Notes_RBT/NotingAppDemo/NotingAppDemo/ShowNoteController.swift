//
//  ShowNoteController.swift
//  NotingAppDemo
//
//  Created by Rational Bits on 04/03/15.
//  Copyright (c) 2015 Rational Bits. All rights reserved.
//

import UIKit



class ShowNoteController: UICollectionViewController {

    var imageArray : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...12{
            imageArray.append("\(i)BG.jpg")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ShowNoteCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as ShowNoteCollectionCell
        
        cell.bgImage.image = UIImage(named: imageArray[indexPath.row])
        return cell
    }


}
