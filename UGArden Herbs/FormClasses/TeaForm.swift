//
//  TeaForm.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 9/20/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Eureka
import Alamofire

class TeaForm: FormViewController, FormUtils,TeaAble {
    var postUrl = AirtableURLs.teaURl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView?.backgroundColor = UIColor(red: 60/255, green: 80/255, blue: 11/255, alpha: 1)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.contentMode = .scaleToFill
        self.navigationItem.title = "Tea Form"
        configureForm()
    }
    
    func configureForm(){
        configureTeaForm()
        form +++ Section("Submit")
            <<< ButtonRow("Submit"){
                $0.title = "Submit!"
                $0.onCellSelection(self.buttonTapped)
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< ButtonRow("Clear"){ row in
                row.onCellSelection(self.buttonTapped)
                }.cellUpdate{cell, row in
                    cell.height = {return 70}
                    cell.textLabel?.attributedText = NSMutableAttributedString(string: "Clear Form", attributes: [.foregroundColor: UIColor.red])
        }
    }
    
}
