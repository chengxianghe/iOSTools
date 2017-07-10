//
//  UIColorExtension.swift
//  MissLi
//
//  Created by chengxianghe on 2017/4/17.
//  Copyright © 2017年 cn. All rights reserved.
//

import Foundation

// MARK:- 把#ffffff或者0xffffff颜色转为UIColor
extension UIColor {
    
    /// 把#ffffff或者0xffffff颜色转为UIColor
    ///
    /// - Parameters:
    ///   - hex: String
    ///   - alpha: CGFload
    /// - Returns: UIColor
    class func colorFromHexString(hex:String, alpha: CGFloat = 1.0) ->UIColor {
        
        var hexString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (hexString.hasPrefix("#")) {
            let index = hexString.index(hexString.startIndex, offsetBy:1)
            hexString = hexString.substring(from: index)
        } else if (hexString.hasPrefix("0X")) {
            let index = hexString.index(hexString.startIndex, offsetBy:2)
            hexString = hexString.substring(from: index)
        }
        
        if (hexString.characters.count != 6) {
            return UIColor.black
        }
        
        var hexValue:  UInt32 = 0
        guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
            return UIColor.black
        }
        
        return self.colorFromHexNumber(hexValue, alpha: alpha)
    }
    
    /// 把0xffffff颜色转为UIColor
    ///
    /// - Parameters:
    ///   - hex6: UInt32
    ///   - alpha: CGFload
    /// - Returns: UIColor
    class func colorFromHexNumber(_ hex6: UInt32, alpha: CGFloat = 1) -> UIColor {
        let red     =   CGFloat((hex6 & 0xFF0000) >> 16) / 255.0
        let green   =   CGFloat((hex6 & 0x00FF00) >> 8)  / 255.0
        let blue    =   CGFloat((hex6 & 0x0000FF))       / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 随机颜色
    ///
    /// - Returns: UIColor
    class func randomColor() -> UIColor {
        let randomRed = CGFloat(arc4random_uniform(256))
        let randomGreen = CGFloat(arc4random_uniform(256))
        let randomBlue = CGFloat(arc4random_uniform(256))
        return UIColor(red: randomRed/255.0, green: randomGreen/255.0, blue: randomBlue/255.0, alpha: 1.0)
    }
}
