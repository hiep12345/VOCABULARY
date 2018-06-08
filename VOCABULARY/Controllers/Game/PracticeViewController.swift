//
//  PracticeViewController.swift
//  VOCABULARY
//
//  Created by MAC on 5/21/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit

class PracticeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let reuseIdentifier = "ChooseImgCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    fileprivate let itemsPerRow: CGFloat = 1
    fileprivate var itemCards:[ItemCard] = []
    let itemRepository   = ItemsRepository.shared
    
}

//MARK:LIFE CYCLE
extension PracticeViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupView()
    }
}

//MARK: OTHER METHOD
extension PracticeViewController {
    func setupData(){
        self.itemCards = self.itemRepository.itemCards
        self.collectionView.reloadData()
    }
    
    func setupView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName:"ChooseImageCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    /**
     Scroll to Next Cell
     */
    func scrollToNextCell(){
        //get cell size
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        //get current content Offset of the Collection view
        let contentOffset = self.collectionView.contentOffset;
        
        //scroll to next cell
        self.collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);
    }

    
}
//MARK:UICOLLECTIONVIEW DATASOURCE, DELEGATE

extension PracticeViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.title = "\(indexPath.row + 1)/50"
        // 1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! ChooseImageCell
        
        cell.delegate = self
        return cell
    }
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth
        let heightItem   = view.frame.height
        return CGSize(width: widthPerItem, height: heightItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

//MARK: CHOOSEIMAGE DELEGATE
extension PracticeViewController : ChooseImageCellDelegate {
    func chooseImgTrue() {
        self.scrollToNextCell()
    }
}
