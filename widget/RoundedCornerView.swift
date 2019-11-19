//
//  RoundedCornerView.swift
//  widget
//
//  Created by Сергей Прищенко on 19.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {
    
    // if cornerRadius variable is set/changed, change the corner radius of the UIView
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
