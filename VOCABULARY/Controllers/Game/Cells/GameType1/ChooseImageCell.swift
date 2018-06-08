//
//  ChooseImageCell.swift
//  VOCABULARY
//
//  Created by MAC on 5/28/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit
protocol ChooseImageCellDelegate {
    func chooseImgTrue()
}
class ChooseImageCell: UICollectionViewCell{
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var imgcollectionView: UICollectionView!
    var delegate:ChooseImageCellDelegate?
    var itemRepository = ItemsRepository.shared
    var values:([ItemCard],ItemCard?) = ([],nil)
    fileprivate let indentifier = "ImgCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        values = itemRepository.getItemsRandomForGame1()
        self.lblWord.text = values.1?.word
        imgcollectionView.dataSource = self
        imgcollectionView.delegate   = self
        self.imgcollectionView.register(UINib(nibName:"ImgCell", bundle: nil), forCellWithReuseIdentifier: indentifier)
    }
}

extension ChooseImageCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imgcollectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath ) as! ImgCell
        cell.img.sd_setImage(with: URL(string: values.0[indexPath.row].imgURL!), placeholderImage:  UIImage(named: "noImage"), options: .delayPlaceholder, completed: nil)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if values.0[indexPath.row].id == values.1?.id {
            self.delegate?.chooseImgTrue()
            print("đúng rồi")
        }else{
            print("sai rồi")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = self.frame.width/2 - 40.0
        let widthPerItem = availableWidth
        let heightItem   = self.frame.height/4 - 40.0
        return CGSize(width: widthPerItem, height: heightItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
