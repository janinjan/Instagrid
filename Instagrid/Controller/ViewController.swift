//
//  ViewController.swift
//  Instagrid
//
//  Created by Janin Culhaoglu on 06/03/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var mainView: LayoutView!
    
    @IBOutlet var layoutsButton: [UIButton]!
    
    @IBAction func layoutButtonsTapped(_ sender: UIButton) {
        layoutsButton.forEach({ $0.isSelected = false })
        sender.isSelected = true
        switch sender.tag {
        case 0:
            mainView.layoutStyle = .layout1
        case 1:
            mainView.layoutStyle = .layout2
        case 2:
            mainView.layoutStyle = .layout3
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layoutStyle = .layout2
    }
}
