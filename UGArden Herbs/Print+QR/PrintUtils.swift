//
//  PrintUtils.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 10/2/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import UIKit
import Eureka

//147 pixels ~= 2 in. width
protocol PrintUtils {
    func createView(image: UIImage, info: [String : Any?]) -> UIImage
    func printLabel(image: UIImage)
}

extension PrintUtils where Self : FormViewController & Dryable {
    
    /**
     First creates a UIView with all the contents that need to be displayed by the label, then converts it to an image
     - parameters:
     - image: the QRcode included in the label. Should contain ALL !nil values in the form.
     - info: The values that should be displayed in the label.
     
     I chose to handle it this way because Views are easier to construct and layout, and turning it into an image was relatively simple.Printing images is pretty simple as well, so this seemed like the best route.
     */
    //old width: 294
    func createView(image: UIImage, info: [String:Any?]) -> UIImage {
        let label = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 150))
        label.backgroundColor = .white
        let qrView = UIImageView(image: image)
        label.addSubview(qrView)
        qrView.snp.makeConstraints{
            $0.bottom.right.equalToSuperview().inset(10)
            $0.height.equalTo(100)
            $0.width.equalTo(100)
        }

        // FOR LABEL:
        //
        // Include Crop name first (duh)
        // Lot #
        // Then Date harvested
        //
        
        for (index,item) in info.enumerated() {
            var val = ""
            if let value = item.value {
                if(value is Date){
                    val = item.key + ": " + (dateFormatter?.string(from: value as! Date))!
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
    //https://stackoverflow.com/questions/30696307/how-to-convert-a-uiview-to-an-image
    //Actual magic.
    func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }

    }
}

