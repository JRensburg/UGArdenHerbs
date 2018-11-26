//
//  TableViewController.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 9/18/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import SnapKit

class IntroView: UITableViewController{

    @IBOutlet var cellImageView: UIImageView!
    
    let sectionNames: [(String,String)] = [("Seeding Form","seeds-blur.jpg"), ("Drying Form","orange-blur.jpg"), ("Tea Form","flower-blur.jpg"),("View Data","basil-blur.jpg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
   // self.tableView.backgroundView = UIImageView(image: UIImage(named: "dryHerbs.jpg"))
        self.view.backgroundColor = UIColor(red: 138/255, green: 158/255, blue: 87/255, alpha: 1)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
//        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 3, height: ((self.navigationController?.navigationBar.frame.height)! * 0.95
//
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: (self.navigationController?.navigationBar.frame.size.height)!)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height-(self.navigationController?.navigationBar.frame.size.height)!) / 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IntroCell
        let attribtues: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Muli-Light", size: 58)!]
        let title = NSAttributedString(string: sectionNames[indexPath.row].0, attributes: attribtues)
        cell.textLabel?.adjustsFontSizeToFitWidth = true

        cell.textLabel?.attributedText = title
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.shadowColor = .black
        cell.textLabel?.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.backgroundImage.image = UIImage(named: sectionNames[indexPath.row].1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch indexPath.row {
        case 0:
            let vc = storyBoard.instantiateViewController(withIdentifier: "SeedingForm") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            print("we trying")
            let vc = storyBoard.instantiateViewController(withIdentifier: "HerbFormController") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        
        case 2:
            let vc = storyBoard.instantiateViewController(withIdentifier: "TeaForm") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewData")
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            print("oops")
        }
    }
}

class IntroCell : UITableViewCell {
    
    @IBOutlet var backgroundImage: UIImageView!

//    override var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame =  newFrame
//            frame.origin.y += 4
//            frame.size.height -= 2 * 5
//            super.frame = frame
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImage.contentMode = .center
        
//        let effect = UIBlurEffect(style: .extraLight)
//        let effectView = UIVisualEffectView(effect: effect)
//        effectView.frame = self.contentView.frame
//        self.backgroundImage.addSubview(effectView)
//
//        self.contentView.backgroundColor = .clear
//        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.frame.size.width - 20, height: self.frame.height - 10))
//        whiteRoundedView.layer.backgroundColor = UIColor(red: 138/255, green: 158/255, blue: 87/255, alpha: 1).cgColor
//        whiteRoundedView.layer.masksToBounds = false
//        whiteRoundedView.layer.cornerRadius = 2.0
//        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
//        whiteRoundedView.layer.shadowOpacity = 0.2
//        backgroundImage.addSubview(whiteRoundedView)
    }
    
}


