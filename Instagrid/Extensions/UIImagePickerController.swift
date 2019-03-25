//
//  UIImagePickerController.swift
//  Instagrid
//
//  Created by Janin Culhaoglu on 21/03/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    
    open override var shouldAutorotate: Bool { return true }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .all }
}
