//
//  UICollectionView+RegisterCell.swift
//  Pods
//
//  Created by Maxim Soloviev on 26/04/2017.
//
//

import UIKit

extension UICollectionView {
    
    open func or_registerCellNib(forClass cellClass: AnyClass) {
        let nib = UINib(nibName: String(describing: cellClass), bundle:nil)
        register(nib, forCellWithReuseIdentifier: String(describing: cellClass))
    }
}
