//
//  LayoutView.swift
//  Instagrid
//
//  Created by Janin Culhaoglu on 13/03/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

/**
 * LayoutView inherits from UIView class. It defines the main grid view
 */
class LayoutView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private var topStackView: UIStackView!
    @IBOutlet private var bottomStackView: UIStackView!
    @IBOutlet var picturesButton: [UIButton]!
    @IBOutlet var picturesCollectionImageView: [UIImageView]!
    
    // MARK: - Properties
    var layoutStyle: LayoutStyle = .layout3 {
        didSet {
            setLayoutStyle(layoutStyle)
        }
    }
    
    // MARK: - Methods
    /**
     * Displays views according to layout style 1, 2 or 3
     */
    private func setLayoutStyle(_ layoutStyle: LayoutStyle) {
        switch layoutStyle {
        case .layout1:
            topStackView.viewWithTag(1)?.isHidden = true
            bottomStackView.viewWithTag(3)?.isHidden = false
        case .layout2:
            topStackView.viewWithTag(1)?.isHidden = false
            bottomStackView.viewWithTag(3)?.isHidden = true
        case .layout3:
            topStackView.viewWithTag(1)?.isHidden = false
            bottomStackView.viewWithTag(3)?.isHidden = false
        }
    }
    
    /**
     * Check if picture is missing in selected grid
     */
    func missingPictureInGrid() -> Bool {
        for picture in picturesCollectionImageView {
            if let parentView = picture.superview { // parentView: view 0, 1, 2, 3
                if parentView.isHidden == false &&  picture.image == nil {
                    return true
                }
            }
        }
        return false
    }
}
