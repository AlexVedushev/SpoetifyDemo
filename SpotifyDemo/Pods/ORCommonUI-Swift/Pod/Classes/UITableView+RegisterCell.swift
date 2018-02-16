//
//  UITableView+RegisterCell.swift
//  Pods
//
//  Created by Maxim Soloviev on 26/04/2017.
//
//

import UIKit

extension UITableView {
    
    open func or_registerCellNib(forClass cellClass: AnyClass) {
        let nib = UINib(nibName: String(describing: cellClass), bundle:nil)
        register(nib, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    open func or_registerHeaderNib(forClass cellClass: AnyClass) {
        let nib = UINib(nibName: String(describing: cellClass), bundle:nil)
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: cellClass))
    }
}
