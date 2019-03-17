//
//  LayoutView.swift
//  Instagrid
//
//  Created by Janin Culhaoglu on 13/03/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

class LayoutView: UIView {
    
    @IBOutlet private var topStackView: UIStackView!
    @IBOutlet private var bottomStackView: UIStackView!
    
    
    var layoutStyle: LayoutStyle = .layout3 {
        didSet {
            setLayoutStyle(layoutStyle)
        }
    }
    
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
}
