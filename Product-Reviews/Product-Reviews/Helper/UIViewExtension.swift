//
//  UIViewExtension.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/24/21.
//

import UIKit

@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    func setRoundedToView(_ viewToRound: UIView, byCorners: UIRectCorner){
        //[.topRight, .bottomLeft],
        let path = UIBezierPath(roundedRect:viewToRound.bounds, byRoundingCorners:byCorners, cornerRadii: CGSize(width: 20, height:  20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        viewToRound.layer.mask = maskLayer
    }
}
