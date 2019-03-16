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
    
    let sectionNames: [(String,String)] = [("Seeding Form","seeds-blur.jpg"), ("Drying Form","orange-blur.jpg"), ("Tea Form","flower-blur.jpg"),("View Data","basil-blur.jpg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.view.backgroundColor = UIColor(red: 138/255, green: 158/255, blue: 87/255, alpha: 1)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))

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
            let vc = storyBoard.instantiateViewController(withIdentifier: "HerbFormController") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = storyBoard.instantiateViewController(withIdentifier: "TeaForm") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewData")
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            print("This should never happen")
        }
    }
}

class IntroCell : UITableViewCell {
    
    @IBOutlet var backgroundImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImage.contentMode = .center
    }
    
}


