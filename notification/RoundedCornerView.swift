//
//  RoundedCornerView.swift
//  notification
//
//  Created by Сергей Прищенко on 24.06.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
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
