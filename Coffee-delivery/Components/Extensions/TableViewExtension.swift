//
//  TableViewExtension.swift
//  Coffee-delivery
//
//  Created by User on 24/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

extension UITableView {
    
    func removeExtraCellLines() {
        tableFooterView = UIView(frame: .zero)
    }
    
}

extension UITableViewCell {
    func separator(hide: Bool) {
        separatorInset.left = hide ? bounds.size.width : 0
    }
}
