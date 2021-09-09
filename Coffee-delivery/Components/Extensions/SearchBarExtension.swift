//
//  SearchBarExtension.swift
//  Coffee-delivery
//
//  Created by User on 06/09/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    var compatibleSearchTextField: UITextField {
        guard #available(iOS 13.0, *) else { return legacySearchField }
        return self.searchTextField
    }
    
    private var legacySearchField: UITextField {
        if let textField = self.subviews.first?.subviews.last as? UITextField {
            // Xcode 11 previous environment
            return textField
        } else if let textField = self.value(forKey: "searchField") as? UITextField {
            // Xcode 11 run in iOS 13 previous devices
            return textField
        } else {
            // exception condition or error handler in here
            return UITextField()
        }
    }
    
    func setCenteredPlaceHolder() {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        
        //get the sizes
        let searchBarWidth = self.frame.width
        let placeholderIconWidth = textFieldInsideSearchBar?.leftView?.frame.width
        let placeHolderWidth = textFieldInsideSearchBar?.attributedPlaceholder?.size().width
        let offsetIconToPlaceholder: CGFloat = 8
        let placeHolderWithIcon = placeholderIconWidth! + offsetIconToPlaceholder
        
        let offset = UIOffset(horizontal: ((searchBarWidth / 2) - (placeHolderWidth! / 2) - placeHolderWithIcon), vertical: 0)
        
        self.setPositionAdjustment(offset, for: .search)
    }
    
    func removeCenteredPlaceHolder() {
        let offset = UIOffset(horizontal: 0, vertical: 0)
        UIView.animate(withDuration: 1) {
            self.setPositionAdjustment(offset, for: .search)
        }
    }
}
