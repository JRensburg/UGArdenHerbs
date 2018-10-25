//
//  PrintUtils.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 10/2/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import UIKit
import SimplePDF
import Eureka
//TODO Implement
//147 pixels wshould be 2 in. width
protocol PrintUtils {
    func createView(image: UIImage, info: [String : Any?]) -> UIImage
    func printLabel(image: UIImage)
}

extension PrintUtils where Self : HerbFormController{
    
    func createView(image: UIImage, info: [String:Any?]) -> UIImage {
        let label = UIView(frame: CGRect(x: 0, y: 0, width: 294, height: 150))
        label.backgroundColor = .white
        let qrView = UIImageView(image: image)
        label.addSubview(qrView)
        qrView.snp.makeConstraints{
            $0.bottom.right.equalToSuperview().inset(10)
            $0.height.equalToSuperview().dividedBy(1.5)
            $0.width.equalToSuperview().dividedBy(3)
        }
        let logo = UIImageView(image: UIImage(named: "logo.png"))
        label.addSubview(logo)
        logo.contentMode = .scaleAspectFit
        logo.snp.makeConstraints{
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalToSuperview().dividedBy(8)
            $0.left.top.equalToSuperview().offset(5)
        }
        
        for (index,item) in info.enumerated() {
            var val = ""
            if let value = item.value {
                if(value is Date){
                    val = item.key + ": " + (formatter?.string(from: value as! Date))!
                } else if (value is Int){
                    val = item.key + ": " + String((value as! Int))
                } else if (value is Double){
                    val = item.key + ": " + String((value as! Double))
                } else {
                    val = value as! String
                }
            }
        
            let textLabel = UILabel()
            textLabel.text = val
            textLabel.font = UIFont(name: "KohinoorDevanagari-Light", size: CGFloat(10))
            label.addSubview(textLabel)
            textLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(index * 15 + 35)
                $0.left.equalToSuperview().offset(10)
                $0.height.equalToSuperview().dividedBy(12)
                $0.width.lessThanOrEqualTo(label.snp.width).dividedBy(2)
            }
            
        }
        
        return label.toImage()
    }
    
}

extension UIView {
    func toImage() -> UIImage {
        //UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        
//        UIGraphicsBeginImageContextWithOptions(self.frame.size,false, CGFloat(1))
//
//            self.drawHierarchy(in: self.frame, afterScreenUpdates: false)
//
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return image ?? UIImage(imageLiteralResourceName: "orange.jpg")

    }
}

